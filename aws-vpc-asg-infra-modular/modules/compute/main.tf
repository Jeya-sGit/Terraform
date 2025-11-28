resource "aws_security_group" "ALB_SG" {
    name = "ApplicationLoadBalancer-SG"
    description = "Security Group for Application Load Balancer"
    vpc_id = aws_vpc.Custom_VPC.id  
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
    name = "EC2-Instance-SG"
    description = "Security Group for EC2 Instances"
    vpc_id = aws_vpc.Custom_VPC.id  
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [aws_security_group.ALB_SG.id]
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
    name               = "Application-Load-Balancer"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.ALB_SG.id]
    subnets            = aws_subnet.Public_Subnet[*].id
    depends_on         = [aws_internet_gateway.IGW_Custom_VPC]

    tags = {
        Name = "terraform-created-ALB"
    }
  
}

resource "aws_lb_target_group" "App_LB-EC2-TG" {
    name = "App-LB-EC2-Target-Group"
    port = 80
    protocol = "HTTP"  
    vpc_id = aws_vpc.Custom_VPC.id
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
    name = "Python-WebServer"
    image_id = "ami-0d176f79571d18a8f"
    instance_type = "t2.micro"

    network_interfaces {
      associate_public_ip_address = false
      security_groups = [ aws_security_group.EC2-SG.id ]
    }

    user_data = filebase64("lauchScript.sh")

    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "terraform-created-EC2-Instance"
       }
    }
}

resource "aws_autoscaling_group" "ASG-EC2" {
    desired_capacity     = 2
    max_size             = 3
    min_size             = 2
    vpc_zone_identifier  = aws_subnet.Private_Subnet[*].id
    target_group_arns = [aws_lb_target_group.App_LB-EC2-TG.arn]
    launch_template {
        id      = aws_launch_template.EC2_Launch_Template.id
        version = "$Latest"
    }
    health_check_type = "EC2"
    
  
}