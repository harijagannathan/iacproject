resource "aws_vpc" "vpc_main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${upper(terraform.workspace)} Custom VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.public_subnet_cidrs[count.index]

  tags = {
    Name = "${upper(terraform.workspace)} Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.private_subnet_cidrs[count.index]

  tags = {
    Name = "${upper(terraform.workspace)} Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "custom_internet_gateway" {
  vpc_id = aws_vpc.vpc_main.id
}

resource "aws_route_table" "custom_vpc_public_route" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_internet_gateway.id
  }
}

resource "aws_route_table_association" "custom_vpc_public_route_subnets" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.custom_vpc_public_route.id
}

resource "aws_eip" "elastic_ip_for_nat_gateway" {
  depends_on = [aws_internet_gateway.custom_internet_gateway]
  tags = {
    Name = "${upper(terraform.workspace)} Elastic IP for NAT Gateway"
  }
}

resource "aws_nat_gateway" "custom_nat_gateway" {
  allocation_id = aws_eip.elastic_ip_for_nat_gateway.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${upper(terraform.workspace)} NAT Gateway for Private Subnets"
  }

  depends_on = [aws_internet_gateway.custom_internet_gateway]
}

resource "aws_route_table" "custom_vpc_private_route" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.custom_nat_gateway.id
  }
}

resource "aws_route_table_association" "custom_vpc_private_route_subnets" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.custom_vpc_private_route.id
}