module "network" {
    source = "./modules/vpc"
    project_name = var.project_name
    cidr_block = var.cidr_block
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    availability_zones = var.availability_zones
    environment = var.environment
}