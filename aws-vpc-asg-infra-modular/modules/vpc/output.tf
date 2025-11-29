output "vpc_id" {
  description = "The ID of the custom VPC."
  value       = aws_vpc.Custom_VPC.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the custom VPC."
  value       = aws_vpc.Custom_VPC.cidr_block
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
  # Uses the EIP resource which holds the public IP
  value       = aws_eip.eip_vpc[*].public_ip
}

output "nat_gateway_ids" {
  description = "IDs of all NAT Gateways deployed across AZs."
  value       = aws_nat_gateway.NATGW_Custom_VPC[*].id
}