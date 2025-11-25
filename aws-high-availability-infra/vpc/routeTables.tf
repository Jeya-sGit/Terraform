resource "aws_route_table" "VPCDemoTerraform-rtb-public" {
  vpc_id = aws_vpc.VPCDemoTerraform.id

  tags = {
    Name = "VPCDemoTerraform-rtb-public"
  }
  
}

resource "aws_route_table" "VPCDemoTerraform-rtb-private1-ap-south-1a" {
  vpc_id = aws_vpc.VPCDemoTerraform.id

  tags = {
    Name = "VPCDemoTerraform-rtb-private1-ap-south-1a"
  }
  
}

resource "aws_route_table" "VPCDemoTerraform-rtb-private2-ap-south-1b" {
  vpc_id = aws_vpc.VPCDemoTerraform.id

  tags = {
    Name = "VPCDemoTerraform-rtb-private2-ap-south-1b"
  }
  
}