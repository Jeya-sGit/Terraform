resource "aws_vpc" "VPCDemoTerraform" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPCDemo_Terraform"
  }
  
}