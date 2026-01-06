data "http" "my_public_ip" {
  url = "https://ipv4.icanhazip.com"
}

//Security Groups Definition

//1. Security Group for Application Load Balancer
resource "aws_security_group" "ALB-SG" {
  name   = "${var.project_name}-ALB-SG"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-LoadBalance-SG"
  }
}

//2. Security Group for EC2 Instances in Auto Scaling Group
resource "aws_security_group" "WebServer-SG" {

  name   = "${var.project_name}-Webserver-SG"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ALB-SG.id]
  }
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.ALB-SG.id]
  }
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.ALB-SG.id]
  }
  //Lesson:Eventhough SG are Stateful , Always add an egress rule in EC2-SG or EC2 can't download updates!
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-WebServer-SG"
  }
}

//AWS SSM Role and Instance Profile Definition
resource "aws_iam_role" "ssm_role" {
  name = "${var.project_name}-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

//Bridge between Role and EC2 Instances
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.project_name}-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

//Application Load Balancer and Target Groups Definition
resource "aws_alb" "Application_LB" {
    name="${var.project_name}-ALB"
    internal=false
    load_balancer_type = "application"
    security_groups = [aws_security_group.ALB-SG.id]
    subnets = var.public_subnet_ids
    tags = {
      Name="${var.project_name}-LB-Tag"
    }
}

resource "aws_alb_target_group" "ALB_ApacheTG" {
    name = "${var.project_name}-Target-Group"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
    health_check {
        path = "/"
        port = "80"
        protocol = "HTTP"
        matcher = "200-399"//status code range
        interval = 30
        timeout = 5
        healthy_threshold = 5
        unhealthy_threshold = 2
    }
    tags = {
      Name="${var.project_name}-TargetGroup-Tag"
    }
}

resource "aws_alb_target_group" "ALB_JavaTG" {
    name="${var.project_name}-java-tg"
    port=8080
    protocol = "HTTP"
    vpc_id=var.vpc_id
    health_check{
        path="/"
        port="80"
        protocol="HTTP"
        matcher="200-399"
        interval=30
        timeout=5
        healthy_threshold=5
        unhealthy_threshold=2
    }
}

resource "aws_alb_target_group" "ALB_GoTG" {
    name="${var.project_name}-Go-Target-Group"
    port=3000
    protocol = "HTTP"
    vpc_id=var.vpc_id
    health_check {
      path = "/"
      port="80"
      protocol = "HTTP"
      matcher = "200-399"
      interval = 30
      timeout = 5
      healthy_threshold = 5
      unhealthy_threshold = 2
    }
}

resource "aws_alb_listener" "Main_Listener"{
    load_balancer_arn=aws_alb.Application_LB.arn
    port=80
    protocol="HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.ALB_ApacheTG.arn
    }
}

resource "aws_alb_listener_rule" "Java_Listener_Rule"{
    listener_arn=aws_alb_listener.Main_Listener.arn
    priority=100
    action {
        type="forward"
        target_group_arn=aws_alb_target_group.ALB_JavaTG.arn
    }
    condition {
        path_pattern {
            values=["/java*"]
        }
    }
}

resource "aws_alb_listener_rule" "Go_Listener_Rule"{
    listener_arn=aws_alb_listener.Main_Listener.arn
    priority=200
    action {
        type="forward"
        target_group_arn=aws_alb_target_group.ALB_GoTG.arn
    }
   condition {
     path_pattern {
       values = [ "/go*" ]
     }
   }
}

resource "aws_launch_template" "EC2_Launch_Template"{
  name="${var.project_name}-Launch-Template"
  image_id=var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [ aws_security_group.WebServer-SG.id ]
  }

  user_data = filebase64("${path.module}/user_data.sh")
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-EC2-Instance"
    }
  }
} 

resource "aws_autoscaling_group" "ASG_WebServers" {
  name = "${var.project_name}-ASG"
  desired_capacity = var.asg_desired_capacity
  max_size = var.asg_max_size
  min_size = var.asg_min_size
  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns         = [
    aws_alb_target_group.ALB_ApacheTG.arn, 
    aws_alb_target_group.ALB_JavaTG.arn, 
    aws_alb_target_group.ALB_GoTG.arn
  ]
  
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.EC2_Launch_Template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ASG-Instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}