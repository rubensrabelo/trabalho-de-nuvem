output "ip_nginx" {
  description = "IP publico da instancia EC2"
  value       = module.ec2.public_ip
}

output "endpoint_postgres" {
  description = "Endpoint do PostgreSQL"
  value       = module.rds.endpoint
}