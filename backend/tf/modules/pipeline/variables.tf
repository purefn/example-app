variable "ecs_cluster_name" {
  type = string
}

variable "ecs_alb_service_task_name" {
  type = string
}

variable "ecr_repository_name" {
  type = string
}

variable "alb_http_listener_arn" {
  type = string
}

variable "target_groups" {
  type = object({
    blue_name = string
    green_name = string
  })
}

variable "repo_owner" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "branch" {
  type = string
}

