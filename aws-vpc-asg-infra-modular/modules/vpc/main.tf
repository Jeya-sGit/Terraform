resource "aws_vpc" "Custom_VPC" {
  cidr_block = var.vpc_cidr 
  enable_dns_support = true
  enable_dns_hostnames = true   
  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_subnet" "Public_Subnet" {
  vpc_id = aws_vpc.Custom_VPC.id
  count=length(var.vpc_availability_zone )
  cidr_block=cidrsubnet(aws_vpc.Custom_VPC.cidr_block,8,count.index+1)
  availability_zone=element(var.vpc_availability_zone,count.index)
  tags = {
    Name="terraform-created-PublicSubnet ${count.index+1}"
  }
}

resource "aws_subnet" "Private_Subnet" {
  vpc_id = aws_vpc.Custom_VPC.id
  count=length(var.vpc_availability_zone )
  cidr_block=cidrsubnet(aws_vpc.Custom_VPC.cidr_block, 8, count.index + length(var.vpc_availability_zone) + 1)
  availability_zone=element(var.vpc_availability_zone,count.index)
  tags = {
    Name="terraform-created-PrivateSubnet ${count.index+1}"
  } 
}

resource "aws_internet_gateway" "IGW_Custom_VPC" {
  vpc_id = aws_vpc.Custom_VPC.id
  tags = {
    Name = "terraform-created-IGW"
  }
}

resource "aws_route_table" "PublicSubnet_RT"{
    vpc_id=aws_vpc.Custom_VPC.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id=aws_internet_gateway.IGW_Custom_VPC.id
    }
    tags={
        Name="terraform-created-PublicSubnet-RT"
    }
}

resource "aws_route_table_association" "PublicSubnet_RTA"{
    route_table_id = aws_route_table.PublicSubnet_RT.id
    count=length(var.vpc_availability_zone)
    subnet_id = element(aws_subnet.Public_Subnet[*].id,count.index)
}

resource "aws_eip" "eip_vpc"{
    domain="vpc"
    count = length(var.vpc_availability_zone)
    depends_on = [ aws_internet_gateway.IGW_Custom_VPC ]
    tags={
        Name="terraform-created-EIP ${count.index+1}"
    }
}

resource "aws_nat_gateway" "NATGW_Custom_VPC"{
    count = length(var.vpc_availability_zone)
    allocation_id = aws_eip.eip_vpc[count.index].id
    subnet_id=element(aws_subnet.Public_Subnet[*].id,count.index)
    depends_on = [ aws_eip.eip_vpc ]
    tags={
        Name="terraform-created-NATGW ${count.index+1}"
    }
}

resource "aws_route_table" "PrivateSubnet_RT"{
    vpc_id = aws_vpc.Custom_VPC.id
    count = length(var.vpc_availability_zone)
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.NATGW_Custom_VPC[count.index].id
    }
    tags={
        Name="terraform-created-PrivateSubnet-RT ${count.index+1}"
    }
}

resource "aws_route_table_association" "PrivateSubnet_RTA" {
  count=length(var.vpc_availability_zone)
  route_table_id = aws_route_table.PrivateSubnet_RT[count.index].id
  subnet_id=element(aws_subnet.Private_Subnet[*].id,count.index)
}