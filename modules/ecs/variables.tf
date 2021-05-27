variable "container_memory" {
  type = number
}

variable "container_memory_reservation" {
  type = number
}

variable "container_cpu" {
  type = number
}

variable "container_start_timeout" {
  type = number
}

variable "container_stop_timeout" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "cloudwatch_log_group" {
  type = string
}

variable "region" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "target_groups" {
  type = object({
    blue_arn = string
    green_arn = string
  })
}

variable "vpc_security_group_id" {
  type = string
}

variable "vpc_id" {
  type = string
}
