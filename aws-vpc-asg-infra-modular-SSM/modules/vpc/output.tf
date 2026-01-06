output "vpc_id" {
  description = "The ID of the custom VPC."
  value       = aws_vpc.AWS-VPC.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the custom VPC."
  value       = aws_vpc.AWS-VPC.cidr_block
}

output "public_subnet_cidrs" {
  description = "CIDR blocks for all public subnets across AZs."
  value       = aws_subnet.Public_Subnet[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "CIDR blocks for all private subnets across AZs."
  value       = aws_subnet.Private_Subnet[*].cidr_block
}

output "public_subnet_ids" { 
  description = "The IDs for all public subnets across AZs."
  value       = aws_subnet.Public_Subnet[*].id
}

output "private_subnet_ids" {
  description = "The IDs for all private subnets across AZs."
  value       = aws_subnet.Private_Subnet[*].id
}

output "nat_gateway_public_ips" {
  description = "Public IP addresses allocated to the HA NAT Gateways."
  value       = aws_eip.Elastic_IP.public_ip
}

output "nat_gateway_ids" {
  description = "IDs of all NAT Gateways deployed across AZs."
  value       = aws_nat_gateway.NAT_GW.id
}