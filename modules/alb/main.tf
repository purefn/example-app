module "blue_target_group_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = concat(module.this.attributes, ["blue"])
  context    = module.this.context
}

module "alb" {
  source  = "cloudposse/alb/aws"
  version = "0.33.1"

  vpc_id                                  = var.vpc_id
  security_group_ids                      = [var.vpc_security_group_id]
  subnet_ids                              = var.subnet_ids
  internal                                = false
  http_enabled                            = true
  access_logs_enabled                     = true
  alb_access_logs_s3_bucket_force_destroy = true
  cross_zone_load_balancing_enabled       = true
  http2_enabled                           = true
  idle_timeout                            = 60
  ip_address_type                         = "ipv4"
  deletion_protection_enabled             = false
  deregistration_delay                    = 15
  health_check_path                       = "/"
  health_check_port                       = 80
  health_check_healthy_threshold          = 2
  health_check_unhealthy_threshold        = 2
  health_check_interval                   = 15
  target_group_port                       = 80
  target_group_target_type                = "ip"
  target_group_name                       = module.blue_target_group_label.id

  context = module.this.context
}

module "green_target_group_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = concat(module.this.attributes, ["green"])
  context    = module.this.context
}

resource "aws_lb_target_group" "green" {
  name                 = module.green_target_group_label.id
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 15

  health_check {
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = module.green_target_group_label.tags
}

