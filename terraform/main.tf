terraform {
  backend "s3" {
    bucket       = "hemant-ecommerce-tfstate-2026"
    key          = "ecommerce-devops-platform/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}


module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]
  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}


module "iam" {
  source = "./modules/iam"

  project_name           = var.project_name
  environment            = var.environment
  db_password_secret_arn = var.db_password_secret_arn
}


module "security-group" {
  source = "./modules/security-groups"

  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
}


module "alb" {
  source = "./modules/alb"

  vpc_id                = module.vpc.vpc_id
  project_name          = var.project_name
  environment           = var.environment
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security-group.alb_security_group_id

}

module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  environment  = var.environment

  private_subnet_ids    = module.vpc.Private_subnet_ids
  ecs_security_group_id = module.security-group.ecs_security_group_id
  execution_role_arn    = module.iam.ecs_execution_role_arn
  repository_url        = module.ecr.Repository_url
  target_group_arn      = module.alb.target_group_arn

  db_host                = module.rds.endpoint
  db_name                = var.db_name
  db_username            = var.db_username
  db_password_secret_arn = var.db_password_secret_arn

  image_tag = var.image_tag
}


module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.Private_subnet_ids
  security_group_ids = [module.security-group.rds_security_group_id]

  db_password = var.db_password
  db_name     = var.db_name
  db_username = var.db_username
}

















