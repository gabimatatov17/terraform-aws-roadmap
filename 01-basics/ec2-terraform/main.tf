provider "aws" {
    region = var.aws_region
}

resource "aws_eip" "my_eip" {
    domain = "vpc"
    tags = {
      Name = "MyEIP"
    }
}

resource "aws_instance" "ec2_instance" {
    ami                         = var.ami_id 
    instance_type               = var.instance_type
    subnet_id                   = var.subnet_id

    tags = {
        Name = var.instance_name
    }
}

resource "aws_eip_association" "name" {
    instance_id = aws_instance.ec2_instance.id
    allocation_id = aws_eip.my_eip.id
}