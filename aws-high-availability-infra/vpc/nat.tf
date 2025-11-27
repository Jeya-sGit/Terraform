# Single EIP for NAT
resource "aws_eip" "VPCDemoTerraform-nat-eip" {
  vpc = true

  tags = {
    Name = "VPCDemoTerraform-eip-nat"
  }
}

# Single NAT Gateway in Public Subnet 1 (ap-south-1a)
resource "aws_nat_gateway" "VPCDemoTerraform-nat" {
  allocation_id = aws_eip.VPCDemoTerraform-nat-eip.id
  subnet_id     = aws_subnet.VPCDemoTerraform-subnet-public1-ap-south-1a.id

  tags = {
    Name = "VPCDemoTerraform-nat"
  }
}
