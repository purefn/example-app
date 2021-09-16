module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.32.2"

  attributes           = ["ecr"]
  scan_images_on_push  = true
  image_tag_mutability = "MUTABLE"

  context = module.this.context
}

resource "aws_ecs_cluster" "default" {
  name = module.this.id
  tags = module.this.tags
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

module "container_definition" {
  source                       = "cloudposse/ecs-container-definition/aws"
  version                      = "0.56.0"
  container_name               = module.this.id
  container_image              = module.ecr.repository_url
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  start_timeout                = var.container_start_timeout
  stop_timeout                 = var.container_stop_timeout
  # TODO do we need this?
  healthcheck                  = {
    command = [ "CMD-SHELL", "curl -f http://localhost/ || exit 1" ]
    interval = 30
    retries = 3
    startPeriod = 2
    timeout = 5
  }
  environment                  = []
  port_mappings                = [
    {
      containerPort = 80
      hostPort = 80
      protocol = "tcp"
    }
  ]
  /* secrets                      = var.secrets */

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = var.region
      "awslogs-group"         = var.cloudwatch_log_group
      "awslogs-stream-prefix" = module.this.name
    }
    secretOptions = null
  }
}

module "ecs_alb_service_task" {
  # source  = "cloudposse/ecs-alb-service-task/aws"
  # version = "0.55.1"

  # we use a version of the above that has been modified to
  # better support blue/green deployments
  source = "./modules/terraform-aws-ecs-alb-service-task"

  alb_security_group                = var.vpc_security_group_id
  # use_alb_security_group            = var.use_alb_security_group
  # nlb_cidr_blocks                   = var.nlb_cidr_blocks
  # use_nlb_cidr_blocks               = var.use_nlb_cidr_blocks
  container_definition_json         = module.container_definition.json_map_encoded_list
  desired_count                     = var.desired_count
  # health_check_grace_period_seconds = var.health_check_grace_period_seconds
  # task_cpu                          = coalesce(var.task_cpu, var.container_cpu)
  # task_memory                       = coalesce(var.task_memory, var.container_memory)
  ecs_cluster_arn                   = aws_ecs_cluster.default.arn
  # capacity_provider_strategies      = var.capacity_provider_strategies
  # service_registries                = var.service_registries
  launch_type                       = "FARGATE"
  platform_version = "1.4.0"
  vpc_id                            = var.vpc_id
  assign_public_ip                  = false
  security_group_ids                = var.security_group_ids
  subnet_ids                        = var.subnet_ids
  container_port                    = 80
  # nlb_container_port                = var.nlb_container_port
  # volumes                           = var.volumes
  ecs_load_balancers                = [
    {
      container_name   = module.this.id
      container_port   = 80
      elb_name         = null
      target_group_arn = var.target_groups.blue_arn
    }
  ]
  deployment_controller_type        = "CODE_DEPLOY"

  context = module.this.context
}
