resource "aws_launch_template" "terraform-ec2-launch-template" {
  name          = "ec2-by-Terraform"
  image_id      = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform-key.key_name
  security_group_names = [aws_security_group.ec2_sg.name]

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "terraform_ec2_instance"
    }
  }
  
}