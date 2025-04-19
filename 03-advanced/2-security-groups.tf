#### My IP Address ####
data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

#### Web Instance Security Group ####
module "web_instance_security_group" {
    source = "./modules/security-group"
    name = "${var.project_name}-${var.environment}-web-sg"
    description = "Security group for web instances"
    vpc_id = module.network.vpc_id
}

#### DB Instance Security Group ####
module "db_instance_security_group" {
  source = "./modules/security-groups"
  name = var.project_name
  environment = var.environment
  vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  tags = var.tags
}