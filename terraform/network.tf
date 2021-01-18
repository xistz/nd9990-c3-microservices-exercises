resource "aws_vpc" "udagram" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "udagram-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "udagram_public" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.udagram.id
  cidr_block        = cidrsubnet(aws_vpc.udagram.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "udagram-public-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "udagram" {
  vpc_id = aws_vpc.udagram.id

  tags = {
    Name = "udagram-internet-gateway"
  }
}

resource "aws_route_table" "udagram_public" {
  vpc_id = aws_vpc.udagram.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.udagram.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.udagram.id
  }

  tags = {
    Name = "udagram-public-route-table"
  }
}

resource "aws_route_table_association" "udagram_public" {
  count = length(aws_subnet.udagram_public)

  subnet_id      = aws_subnet.udagram_public[count.index].id
  route_table_id = aws_route_table.udagram_public.id
}
