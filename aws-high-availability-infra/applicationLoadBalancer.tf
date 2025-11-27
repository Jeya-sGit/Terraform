#1.AWS LoadBalancer(ALB) Provisioning
resource "aws_lb" "terraform-alb-sg" {  
  name               = "terraform-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.VPCDemoTerraform-subnet-public1-ap-south-1a.id,
    aws_subnet.VPCDemoTerraform-subnet-public2-ap-south-1b.id
  ]
  depends_on = [ aws_internet_gateway.VPCDemoTerraform-igw ]

  tags = {
    Name = "terraform_alb"
  }
  
}
#2.AWS Target Group for ALB
resource "aws_alb_target_group" "terraform-alb-Tg" {
    name     = "terraform-alb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.VPCDemoTerraform.id
    
    health_check {
        interval            = 30
        path                = "/"
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
    }
    
    tags = {
        Name = "terraform_alb_tg"
    }
  
}
#3.AWS Listener for ALB
resource "aws_lb_listener" "terraform-alb-listener" {
    load_balancer_arn = aws_lb.terraform-alb-sg.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_alb_target_group.terraform-alb-Tg.arn
    }  
}