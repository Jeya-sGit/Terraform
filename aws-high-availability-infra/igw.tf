resource "aws_internet_gateway" "VPCDemoTerraform-igw" {
  vpc_id = aws_vpc.VPCDemoTerraform.id

  tags = {
    Name = "VPCDemoTerraform_igw"
  }
  
}