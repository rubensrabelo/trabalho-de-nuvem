variable "region" {
  description = "Regiao AWS"
  type        = string
}

variable "ami" {
  description = "AMI da EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instancia"
  type        = string
}

variable "key_name" {
  description = "Nome do Key Pair"
  type        = string
}

variable "db_password" {
  description = "Senha do PostgreSQL"
  type        = string
  sensitive   = true
}