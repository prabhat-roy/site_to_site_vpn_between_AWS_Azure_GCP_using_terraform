resource "aws_vpc" "aws_vpc" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "AWS VPC"
  }
}

resource "aws_subnet" "aws_subnet" {
  count                   = length(var.aws_subnet_cidrs)
  vpc_id                  = aws_vpc.aws_vpc.id
  cidr_block              = element(var.aws_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "AWS Subnet ${count.index + 1}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id           = aws_vpc.aws_vpc.id
  propagating_vgws = [aws_vpn_gateway.vpn_gateway.id]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "AWS Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.aws_subnet_cidrs)
  subnet_id      = element(aws_subnet.aws_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.aws_vpc.id
  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id          = aws_vpc.aws_vpc.id
  amazon_side_asn = var.aws_bgp_asn
  tags = {
    Name = "AWS VGW"
  }
}