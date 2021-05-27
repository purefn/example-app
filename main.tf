provider "aws" {
  region = var.region
}

resource "aws_cloudwatch_log_group" "app" {
  name              = module.this.id
  tags              = module.this.tags
  retention_in_days = var.log_retention_in_days
}

module "network" {
  source = "./modules/network"

  availability_zones = var.availability_zones
  vpc_cidr_block = var.vpc_cidr_block

  context = module.this.context
}

module "alb" {
  source = "./modules/alb"

  vpc_id = module.network.vpc_id
  vpc_security_group_id = module.network.vpc_default_security_group_id
  subnet_ids = module.network.public_subnet_ids

  context = module.this.context
}

module "ecs" {
  source = "./modules/ecs"

  cloudwatch_log_group = join("", aws_cloudwatch_log_group.app.*.name)
  container_cpu = var.container_cpu
  container_memory = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_start_timeout = var.container_start_timeout
  container_stop_timeout = var.container_stop_timeout
  desired_count = var.desired_count
  region = var.region
  vpc_security_group_id = module.network.vpc_default_security_group_id
  vpc_id = module.network.vpc_id
  security_group_ids = [module.alb.security_group_id]
  subnet_ids = module.network.private_subnet_ids
  target_groups = module.alb.target_groups

  context = module.this.context
}

module "pipeline" {
  source = "./modules/pipeline"

  context = module.this.context

  ecs_alb_service_task_name = module.ecs.alb_service_task_name
  ecs_cluster_name = module.ecs.cluster_name
  ecr_repository_name = module.ecs.repository_name
  alb_http_listener_arn = module.alb.http_listener_arn
  target_groups = module.alb.target_groups

  repo_owner = var.repo_owner
  repo_name = var.repo_name
  branch = var.branch
  github_oauth_token = var.github_oauth_token
}
