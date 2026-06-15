output "public_ip_ec2" {
  description = "IP publico da instancia EC2 mapeada no modulo"
  value       = module.ec2.public_ip
}
