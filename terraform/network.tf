resource "aws_vpc" "udagram" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "udagram-vpc"
  }
}

resource "aws_internet_gateway" "udagram" {
  vpc_id = aws_vpc.udagram.id

  tags = {
    Name = "udagram-internet-gateway"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "udagram_public" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.udagram.id
  cidr_block              = cidrsubnet(aws_vpc.udagram.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "udagram-public-subnet-${count.index}"
  }
}

resource "aws_route_table" "udagram_public" {
  vpc_id = aws_vpc.udagram.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.udagram.id
  }

  tags = {
    Name = "udagram-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.udagram_public)

  subnet_id      = aws_subnet.udagram_public[count.index].id
  route_table_id = aws_route_table.udagram_public.id
}

resource "aws_security_group" "udagram_postgres" {
  name        = "allow-postgres"
  description = "Allow postgres traffic"
  vpc_id      = aws_vpc.udagram.id

  ingress {
    cidr_blocks = [aws_vpc.udagram.cidr_block, "0.0.0.0/0"]
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-postgres"
  }
}
