output "alb_service_task_name" {
  value = module.ecs_alb_service_task.service_name
}

output "cluster_name" {
  value = aws_ecs_cluster.default.name
}

output "repository_url" {
  value = module.ecr.repository_url
}

output "repository_name" {
  value = module.ecr.repository_name
}
