variable "region" {
  type = string
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "log_retention_in_days" {
  type        = number
  description = "The number of days to retain logs for the log group"
  default     = 90
}

variable "container_cpu" {
  type        = number
  description = "The vCPU setting to control cpu limits of container. (If FARGATE launch type is used below, this must be a supported vCPU size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html)"
  default     = 256
}

variable "container_memory" {
  type        = number
  description = "The amount of RAM to allow container to use in MB. (If FARGATE launch type is used below, this must be a supported Memory size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html)"
  default     = 512
}

variable "container_memory_reservation" {
  type        = number
  description = "The amount of RAM (Soft Limit) to allow container to use in MB. This value must be less than `container_memory` if set"
  default     = 128
}

variable "container_start_timeout" {
  type        = number
  description = "Time duration (in seconds) to wait before giving up on resolving dependencies for a container"
  default     = 30
}

variable "container_stop_timeout" {
  type        = number
  description = "Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own"
  default     = 30
}

variable "desired_count" {
  type = number
  description = "The number of instances of the task definition to place and keep running"
  default = 1
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

variable "github_oauth_token" {
  type = string
}
