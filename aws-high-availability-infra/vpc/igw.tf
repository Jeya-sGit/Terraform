resource "aws_internet_gateway" "VPCDemoTerraform-igw" {
  vpc_id = aws_vpc.VPCDemoTerraform-vpc.id

  tags = {
    Name = "VPCDemoTerraform-igw"
  }
  
}