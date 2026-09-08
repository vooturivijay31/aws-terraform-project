module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  ssh_cidr     = var.ssh_cidr
}

module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_security_group_id
}

module "compute" {
  source = "./modules/compute"

  project_name      = var.project_name
  environment       = terraform.workspace
  instance_type     = var.instance_type
  desired_instances = var.desired_instances
  min_instances     = var.min_instances
  max_instances     = var.max_instances
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.ec2_security_group_id
  target_group_arn  = module.alb.target_group_arn
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
}