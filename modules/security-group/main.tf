resource "aws_security_group" "cloud_flow" {
  name        = "cloud_flow"
  description = "Grupo de Seguranca da Disciplina de Nuvem"

  tags = {
    Name = "cloud_flow"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.cloud_flow.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.cloud_flow.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "postgres" {
  security_group_id = aws_security_group.cloud_flow.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.cloud_flow.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}