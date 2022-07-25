provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "vpc" {
  source             = "../../"
  env                = var.vpc_env
  cidr_block         = var.vpc_cidr_block
  service_name       = var.vpc_serice_name
  availability_zones = var.vpc_availability_zones
  database_subnets   = var.vpc_database_subnets
  private_subnets    = var.vpc_private_subnets
  public_subnets     = var.vpc_public_subnets
}
