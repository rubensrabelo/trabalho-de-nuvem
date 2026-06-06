resource "aws_instance" "nginx" {
  ami           = var.ami
  instance_type = var.instance_type

  key_name = var.key_name

  security_groups = [
    var.security_group_name
  ]

  tags = {
    Name = "Nginxinstance"
  }
}