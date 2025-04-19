variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones for the subnets"
  type        = list(string)
}