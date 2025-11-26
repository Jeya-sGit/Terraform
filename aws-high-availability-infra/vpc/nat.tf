#EIP and NAT Gateway for Public Subnet 1 in ap-south-1a
resource "aws_eip" "VPCDemoConsole-eip-nat-public1-ap-south-1a" {
  vpc = true

  tags = {
    Name = "VPCDemoConsole-eip-nat-public1-ap-south-1a"
  }
  
}
resource "aws_nat_gateway" "VPCDemoConsole-nat-public1-ap-south-1a" {
  allocation_id = aws_eip.VPCDemoConsole-eip-nat-public1-ap-south-1a.id
  subnet_id     = aws_subnet.VPCDemoConsole-subnet-public1-ap-south-1a.id

  tags = {
    Name = "VPCDemoConsole-nat-public1-ap-south-1a"
  }
  
}

#EIP and NAT Gateway for Public Subnet 2 in ap-south-1b
resource "aws_eip" "VPCDemoConsole-eip-nat-public2-ap-south-1b" {
  vpc = true

  tags = {
    Name = "VPCDemoConsole-eip-nat-public2-ap-south-1b"
  }
  
}
resource "aws_nat_gateway" "VPCDemoConsole-nat-public2-ap-south-1b" {
  allocation_id = aws_eip.VPCDemoConsole-eip-nat-public2-ap-south-1b.id
  subnet_id     = aws_subnet.VPCDemoConsole-subnet-public2-ap-south-1b.id

  tags = {
    Name = "VPCDemoConsole-nat-public2-ap-south-1b"
  }
  
}