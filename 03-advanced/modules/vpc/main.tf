resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      "Name" = "${var.project_name}-${var.environment}-vpc"
    }
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "${var.project_name}-${var.environment}-igw"
    }
}

resource "aws_subnet" "public_subnet" {
    for_each = { for idx, cidr in var.public_subnet_cidrs : idx => cidr }
    vpc_id = aws_vpc.main.id
    cidr_block = each.value
    availability_zone = var.availability_zones[each.key]
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.project_name}-${var.environment}-public-subnet-${each.key}"
    }  
}

resource "aws_subnet" "private_subnet" {
    for_each = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }
    vpc_id = aws_vpc.main.id
    cidr_block = each.value
    availability_zone = var.availability_zones[each.key]

    tags = {
      Name = "${var.project_name}-${var.environment}-private-subnet-${each.key}"
    }
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet[0].id

    tags = {
      Name = "${var.project_name}-${var.environment}-nat-gateway"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id

    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "${var.project_name}-${var.environment}-public-rt"
    }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id

    route = {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw.id
    }

    tags = {
      Name = "${var.project_name}-${var.environment}-private-rt"
    }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}