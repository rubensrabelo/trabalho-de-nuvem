data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "cloud" {
  name       = "cloud-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "cloud-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "instancia-postgres"

  engine         = "postgres"
  engine_version = "16"

  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "meubanco"
  username = "postgres"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.cloud.name
  vpc_security_group_ids = [var.security_group_id]

  publicly_accessible = false

  skip_final_snapshot     = true
  backup_retention_period = 0

  tags = {
    Name = "instancia-postgres"
  }
}