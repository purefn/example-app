variable "vpc_id" {
  type = string
}

variable "vpc_security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
