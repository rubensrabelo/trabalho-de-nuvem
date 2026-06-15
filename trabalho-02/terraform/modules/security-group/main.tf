resource "aws_security_group" "devops" {
  name        = "devops"
  description = "Grupo de Seguranca da Disciplina de Nuvem"

  tags = {
    Name = "devops"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.devops.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.devops.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.devops.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
