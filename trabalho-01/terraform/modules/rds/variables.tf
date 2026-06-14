variable "db_password" {
  type      = string
  sensitive = true
}

variable "security_group_id" {
  type = string
}