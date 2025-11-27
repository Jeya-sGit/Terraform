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
        Name = "public-ec2-sg"
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
    Name = "private-ec2-sg"
  }
}