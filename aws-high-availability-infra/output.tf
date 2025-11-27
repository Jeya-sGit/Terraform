# VPC ID
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.VPCDemoTerraform.id
}
 
# Public Subnets
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [
    aws_subnet.VPCDemoTerraform-subnet-public1-ap-south-1a.id,
    aws_subnet.VPCDemoTerraform-subnet-public2-ap-south-1b.id
  ]
}

# Private Subnets
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = [
    aws_subnet.VPCDemoTerraform-subnet-private1-ap-south-1a.id,
    aws_subnet.VPCDemoTerraform-subnet-private2-ap-south-1b.id
  ]
}

# Security Groups
output "public_ec2_sg_id" {
  description = "Security group ID for public EC2 instances"
  value       = aws_security_group.public_ec2_sg.id
}

output "private_ec2_sg_id" {
  description = "Security group ID for private EC2 instances"
  value       = aws_security_group.private_ec2_sg.id
}

# NAT Gateway
output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.VPCDemoTerraform-nat.id
}

output "alb_dns_name" {
  value = aws_lb.terraform-alb-sg.dns_name
}