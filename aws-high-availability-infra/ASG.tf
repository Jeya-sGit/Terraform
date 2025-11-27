resource "aws_autoscaling_group" "terraform-asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  target_group_arns = [aws_alb_target_group.terraform-alb-Tg.arn]
  vpc_zone_identifier  = [
    aws_subnet.VPCDemoTerraform-subnet-private1-ap-south-1a.id,
    aws_subnet.VPCDemoTerraform-subnet-private2-ap-south-1b.id
  ]
  launch_template {
    id      = aws_launch_template.terraform-ec2-launch-template.id
    version = "$Latest"
  }
  
  tag {
    key                 = "Name"
    value               = "terraform_asg_instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

}