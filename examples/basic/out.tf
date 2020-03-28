output "id" {
  value = module.vpc.id
}

output "cidr_block" {
  value = module.vpc.cidr_block
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnets_ids" {
  value = module.vpc.private_subnets_ids
}

output "database_subnets_ids" {
  value = module.vpc.database_subnets_ids
}

output "aws_db_subnet_group_name" {
  value = module.vpc.aws_db_subnet_group_name
}
