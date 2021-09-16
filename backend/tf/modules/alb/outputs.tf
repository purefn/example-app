output "security_group_id" {
  value = module.alb.security_group_id
}

output "target_groups" {
  value = {
    blue_arn = module.alb.default_target_group_arn
    blue_name = module.blue_target_group_label.id
    green_arn = aws_lb_target_group.green.arn
    green_name = module.green_target_group_label.id
  }
}

output "http_listener_arn" {
  value = module.alb.http_listener_arn
}

output "dns_name" {
  value = module.alb.alb_dns_name
}
