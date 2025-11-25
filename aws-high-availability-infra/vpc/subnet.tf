resource "aws_subnet" "VPCDemoConsole-subnet-public1-ap-south-1a" {
  vpc_id            = aws_vpc.VPCDemoTerraform.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "VPCDemoConsole-subnet-public1-ap-south-1a"
  }
  
}

resource "aws_subnet" "VPCDemoConsole-subnet-public2-ap-south-1b" {
  vpc_id            = aws_vpc.VPCDemoTerraform.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "VPCDemoConsole-subnet-public2-ap-south-1b"
  }
  
}

resource "aws_subnet" "VPCDemoConsole-subnet-private1-ap-south-1a" {
  vpc_id            = aws_vpc.VPCDemoTerraform.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.az_1

  tags = {
    Name = "VPCDemoConsole-subnet-private1-ap-south-1a"
  }
  
}

resource "aws_subnet" "VPCDemoConsole-subnet-private2-ap-south-1b" {
  vpc_id            = aws_vpc.VPCDemoTerraform.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.az_2

  tags = {
    Name = "VPCDemoConsole-subnet-private2-ap-south-1b"
  }
  
}