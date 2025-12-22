resource "aws_security_group" "ALB_SG" {
    name = "${var.project_name}-ALB-SG"
    description = "Security Group for Application Load Balancer"
    vpc_id = var.vpc_id  
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
   }
   egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]    
    }

    tags = {
        Name = "terraform-created-ALB-SG"
    }   
}  

resource "aws_security_group" "EC2-SG" {
    name = "${var.project_name}-EC2-Instance-SG"
    description = "Security Group for EC2 Instances"
    vpc_id = var.vpc_id  
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups= [aws_security_group.ALB_SG.id]
   }
   egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]    
    }

    tags = {
        Name = "terraform-created-EC2-SG"
    }   
}

resource "aws_alb" "App_LB" {
    name               = "${var.project_name}-AppLoadBalancer"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.ALB_SG.id]
    subnets            = var.public_subnet_ids
    
    tags = {
        Name = "terraform-created-ALB"
    }
  
}

resource "aws_lb_target_group" "App_LB-EC2-TG" {
    name = "${var.project_name}-AppLB-EC2-TG"
    port = 80
    protocol = "HTTP"  
    vpc_id = var.vpc_id
    tags = {
        Name = "terraform-created-ALB-EC2-TG"
    } 
}

resource "aws_lb_listener" "ALB-Listener" {
    load_balancer_arn = aws_alb.App_LB.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.App_LB-EC2-TG.arn
    }

    tags = {
        Name = "terraform-created-ALB-Listener"
    }
}

resource "aws_launch_template" "EC2_Launch_Template"{
    name = "${var.project_name}-WebServer"
    image_id = var.ami_id
    instance_type = var.instance_type
    key_name = var.ssh_key_name

    network_interfaces {
      associate_public_ip_address = false
      security_groups = [ aws_security_group.EC2-SG.id ]
    }

    user_data = filebase64("${path.module}/launchScript.sh")

    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "terraform-created-EC2-Instance"
       }
    }
}

resource "aws_autoscaling_group" "ASG-EC2" {
    desired_capacity     = var.asg_desired_capacity
    max_size             = var.asg_max_size
    min_size             = var.asg_min_size
    vpc_zone_identifier  = var.private_subnet_ids
    target_group_arns = [aws_lb_target_group.App_LB-EC2-TG.arn]
    launch_template {
        id      = aws_launch_template.EC2_Launch_Template.id
        version = "$Latest"
    }
    health_check_type = "ELB"
}