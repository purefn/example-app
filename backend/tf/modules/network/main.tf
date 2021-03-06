module "vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.21.1"
  cidr_block = var.vpc_cidr_block

  context = module.this.context

}

module "subnets" {
  source                   = "cloudposse/dynamic-subnets/aws"
  version                  = "0.39.0"
  availability_zones       = var.availability_zones
  vpc_id                   = module.vpc.vpc_id
  igw_id                   = module.vpc.igw_id
  cidr_block               = module.vpc.vpc_cidr_block
  nat_gateway_enabled      = true
  nat_instance_enabled     = false
  aws_route_create_timeout = "5m"
  aws_route_delete_timeout = "10m"

  context = module.this.context
}

