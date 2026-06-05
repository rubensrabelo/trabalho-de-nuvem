module "security_group" {
  source = "./modules/security-group"
}

module "ec2" {
  source = "./modules/ec2"

  ami                 = var.ami
  instance_type       = var.instance_type
  key_name            = var.key_name
  security_group_name = module.security_group.security_group_name
}

module "rds" {
  source = "./modules/rds"

  db_password       = var.db_password
  security_group_id = module.security_group.security_group_id
}