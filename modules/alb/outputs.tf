output "security_group_id" {
  value = module.alb.security_group_id
}

output "target_groups" {
  value = {
    blue_arn = module.alb.default_target_group_arn
    green_arn = aws_lb_target_group.green.arn
  }
}

output "http_listener_arn" {
  value = module.alb.http_listener_arn
}

output "dns_name" {
  value = module.alb.alb_dns_name
}
