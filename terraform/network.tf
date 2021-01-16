resource "aws_vpc" "udagram" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "udagram-vpc"
  }
}

resource "aws_subnet" "udagram_1" {
  vpc_id            = aws_vpc.udagram.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "udagram-subnet-1"
  }
}

resource "aws_subnet" "udagram_2" {
  vpc_id            = aws_vpc.udagram.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1d"

  tags = {
    Name = "udagram-subnet-2"
  }
}

resource "aws_security_group" "udagram" {
  name   = "udagram-security-group"
  vpc_id = aws_vpc.udagram.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "udagram_dev"
  }
}

resource "aws_internet_gateway" "udagram" {
  vpc_id = aws_vpc.udagram.id

  tags = {
    Name = "udagram-internet-gateway"
  }
}
