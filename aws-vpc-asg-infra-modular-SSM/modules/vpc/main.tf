resource "aws_vpc" "AWS-VPC" {
    cidr_block=var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support=true
    tags={
        Name="${var.project_name}-VPC"
    }
}

resource "aws_internet_gateway" "IGW"{
    vpc_id=aws_vpc.AWS-VPC.id
    tags = {
      Name="${var.project_name}-IGW"
    }
}

resource "aws_subnet" "Public_Subnet"{
    vpc_id=aws_vpc.AWS-VPC.id
    count = length(var.vpc_availability_zone)
    cidr_block=cidrsubnet(aws_vpc.AWS-VPC.cidr_block,8,count.index+1)
    availability_zone = element(var.vpc_availability_zone,count.index)
    tags = {
      Name="${var.project_name}-PublicSubnet-${count.index+1}"
    }
}

resource "aws_subnet" "Private_Subnet"{
    vpc_id = aws_vpc.AWS-VPC.id
    count=length(var.vpc_availability_zone)
    cidr_block = cidrsubnet(aws_vpc.AWS-VPC.cidr_block,8,count.index+length(var.vpc_availability_zone)+1)
    availability_zone = element(var.vpc_availability_zone,count.index)
    tags={
        Name="${var.project_name}-PrivateSubnet-${count.index+1}"
    }
}

resource "aws_route_table" "Public_RT"{
    vpc_id=aws_vpc.AWS-VPC.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id=aws_internet_gateway.IGW.id
    }
    tags = {
      Name="${var.project_name}-PublicRT"
    }
}

resource "aws_route_table_association" "Public_RTA"{
    route_table_id = aws_route_table.Public_RT.id
    count = length(var.vpc_availability_zone)
    subnet_id = element(aws_subnet.Public_Subnet[*].id,count.index)
}

resource "aws_eip" "Elastic_IP"{
    domain = "vpc"
    depends_on = [ aws_internet_gateway.IGW ]
    tags = {
      Name="${var.project_name}-EIP"
    }
}

resource "aws_nat_gateway" "NAT_GW"{
    allocation_id=aws_eip.Elastic_IP.id
    subnet_id=aws_subnet.Public_Subnet[0].id
    depends_on = [ aws_eip.Elastic_IP ]
    tags={
        Name="${var.project_name}-nat-gw"
    }
}

resource "aws_route_table" "Private_RT"{
    vpc_id = aws_vpc.AWS-VPC.id
    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NAT_GW.id
    }
    tags={
        Name="${var.project_name}-PrivateRT"
    }
}

resource "aws_route_table_association" "Private_RTA"{
  route_table_id = aws_route_table.Private_RT.id
  count=length(var.vpc_availability_zone)
  subnet_id=element(aws_subnet.Private_Subnet[*].id,count.index)
}