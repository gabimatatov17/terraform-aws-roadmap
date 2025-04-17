
#### Terraform Configuration and Providers ####
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.22.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

#### My IP Address ####
data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

#### VPC ####
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#### Internet Gateway ####
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

#### Elastic IP ####
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

#### NAT Gateway ####
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.project_name}-nat-gw"
  }
}

#### Public and Private Subnets ####
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.project_name}-private-${count.index + 1}"
  }
}

#### Route Tables & Route Table Association ####
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

#### Security Group ####
resource "aws_security_group" "web_sg" {
    name    = "${var.project_name}-web-sg"
    description = "Allow HTTP and HTTPS inbound traffic"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
        description = "Allow SSH from my IP"
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-web-sg"
    }
}

resource "aws_security_group" "db_sg" {
    name = "${var.project_name}-db-sg"
    description = "Allow DB inbound traffic"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port          = 3306
        to_port            = 3306
        protocol           = "tcp"
        security_groups = [aws_security_group.web_sg.id]
    }
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = [aws_security_group.web_sg.id]
        description     = "Allow SSH from web SG"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.project_name}-db-sg"
    }
}

#### EC2 Instance ####
resource "aws_instance"  "web" {
    ami                    = var.web_ami
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.public[0].id
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    depends_on             = [aws_instance.db]

    # user_data              = file("./user-data/web.sh")
    user_data = <<-EOF
            #!/bin/bash
            dnf update -y
            dnf install -y httpd
            systemctl enable httpd
            systemctl start httpd
            echo "<h1>Welcome to the Web Server</h1>" > /var/www/html/index.html
            EOF
    key_name               = "CharlesDataOps1"

    tags = {
        Name = "${var.project_name}-web-instance"
    }   
}

resource "aws_instance"  "db" {
    ami                    = var.db_ami
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.private[0].id
    vpc_security_group_ids = [aws_security_group.db_sg.id]
    # user_data              = file("user-data/db.sh")
    user_data = <<-EOF
            #!/bin/bash
            dnf update -y
            dnf install -y mariadb105-server
            systemctl enable mariadb
            systemctl start mariadb
            EOF

    key_name               = "CharlesDataOps1"
    tags = {
        Name = "${var.project_name}-db-instance"
    }   
}