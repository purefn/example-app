output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_default_security_group_id" {
  value = module.vpc.vpc_default_security_group_id
}

output "private_subnet_ids" {
  value = module.subnets.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.subnets.public_subnet_ids
}
