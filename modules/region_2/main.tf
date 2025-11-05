terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"  # Adjust version if needed
    }
  }
}

#provider "aws" {
#  region = var.region  # Define region here
#}

resource "aws_vpc" "vpc" {
  provider               = aws
  cidr_block             = "10.1.0.0/16"
  enable_dns_support     = true
  enable_dns_hostnames   = true
  tags = {
    Name = "vpc-region-2"
  }
}

resource "aws_subnet" "subnet" {
  provider                = aws
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-region-2"
  }
}

resource "aws_internet_gateway" "igw" {
  provider = aws
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_route_table" "rt" {
  provider = aws
  vpc_id   = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  provider       = aws
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  provider    = aws
  name        = "allow-ssh-http"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

}
resource "aws_db_instance" "rds" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "admin1234"
  skip_final_snapshot    = true
}

# S3
resource "aws_s3_bucket" "bucket" {
  bucket = "multi-region-demo-primary"
  versioning { enabled = true }
}

