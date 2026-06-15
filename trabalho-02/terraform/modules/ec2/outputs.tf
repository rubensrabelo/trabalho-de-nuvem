output "public_ip" {
  description = "IP público gerado para a instância EC2"
  value       = aws_instance.host_ec2.public_ip
}
