#1.Security Group for ALB(Internet -> ALB)
resource "aws_security_group" "alb_sg " {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.VPCDemoTerraform.id

    ingress {
        description = "HTTP from anywhere"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "All outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name="terraform_alb_sg"
    }

}

#2.Security Group for EC2 instances behind ALB (ALB -> EC2)
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Security group for EC2 instances behind ALB"
  vpc_id      = aws_vpc.VPCDemoTerraform.id

    ingress {
        description       = "HTTP from ALB"
        from_port         = 80
        to_port           = 80
        protocol          = "-1"
        security_groups   = [aws_security_group.alb_sg.id]
    }
    egress {
        description = "All outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name="terraform_ec2_sg"
    }    
} 

#Provision a security group for public EC2 instances
resource "aws_security_group" "public_ec2_sg"{
    name="public-ec2-sg"
    description="Security group for public EC2 instances"
    vpc_id=aws_vpc.VPCDemoTerraform.id

    ingress {
        description = "SSH from my IP"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["157.51.37.120/32"]
    }
    ingress {
        description = "SSH from my IP"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["157.51.37.120/32"]
    }
    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "All outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "public_ec2_sg"
    }
}    

#Provision a security group for private EC2 instances
resource "aws_security_group" "private_ec2_sg"{
    name="private-ec2-sg"
    description="Security group for private EC2 instances"
    vpc_id=aws_vpc.VPCDemoTerraform.id

    ingress {
    description            = "Traffic from public EC2"
    from_port              = 0
    to_port                = 0
    protocol               = "-1"
    security_groups        = [aws_security_group.public_ec2_sg.id]
  }

  # Outbound to anywhere (via NAT)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_ec2_sg"
  }
}