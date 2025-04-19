variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
}

variable "vpc_id" {
    description = "VPC ID to create the security group in"
    type        = string
}

variable "ingress_rules" {
    description = "List of ingress rules to apply to the security group"
    type        = list(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
    }))
    #default     = []
}

variable "egress_rules" {
    description = "List of egress rules to apply to the security group"
    type        = list(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
    }))
    default = [{
        description = "Allow all egress"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }]
}
