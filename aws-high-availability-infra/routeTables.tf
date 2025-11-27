#Public Route Table
resource "aws_route_table" "VPCDemoTerraform-rtb-public" {
  vpc_id = aws_vpc.VPCDemoTerraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.VPCDemoTerraform-igw.id
  }

  tags = {
    Name = "VPCDemoTerraform_rtb_public"
  }
  
}
resource "aws_route_table_association" "VPCDemoTerraform-rtb-assoc-public1-ap-south-1a" {
  subnet_id      = aws_subnet.VPCDemoTerraform-subnet-public1-ap-south-1a.id
  route_table_id = aws_route_table.VPCDemoTerraform-rtb-public.id
  
}
resource "aws_route_table_association" "VPCDemoTerraform-rtb-assoc-public2-ap-south-1b" {
  subnet_id      = aws_subnet.VPCDemoTerraform-subnet-public2-ap-south-1b.id
  route_table_id = aws_route_table.VPCDemoTerraform-rtb-public.id
  
}
#Private Route Tables
resource "aws_route_table" "VPCDemoTerraform-private-1a" {
  vpc_id = aws_vpc.VPCDemoTerraform.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.VPCDemoTerraform-nat.id
  }

  tags = {
    Name = "VPCDemoTerraform_rtb_private_1a"
  }
}
resource "aws_route_table_association" "VPCDemoTerraform-private-1a-assoc" {
  subnet_id      = aws_subnet.VPCDemoTerraform-subnet-private1-ap-south-1a.id
  route_table_id = aws_route_table.VPCDemoTerraform-private-1a.id
}

resource "aws_route_table" "VPCDemoTerraform-private-1b" {
  vpc_id = aws_vpc.VPCDemoTerraform.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.VPCDemoTerraform-nat.id
  }

  tags = {
    Name = "VPCDemoTerraform_rtb_private_1b"
  }
}
resource "aws_route_table_association" "VPCDemoTerraform-private-1b-assoc" {
  subnet_id      = aws_subnet.VPCDemoTerraform-subnet-private2-ap-south-1b.id
  route_table_id = aws_route_table.VPCDemoTerraform-private-1b.id
}