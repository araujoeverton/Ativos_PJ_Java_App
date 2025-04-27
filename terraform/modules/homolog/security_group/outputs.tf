output "app_security_group_id" {
  description = "ID do security group da aplicação Spring Boot"
  value       = aws_security_group.app_sg.id
}

output "app_security_group_name" {
  description = "Nome do security group da aplicação"
  value       = aws_security_group.app_sg.name
}

output "app_security_group_vpc" {
  description = "VPC associada ao security group da aplicação"
  value       = aws_security_group.app_sg.vpc_id
}

output "app_security_group_ingress_rules" {
  description = "Regras de entrada configuradas para a aplicação Spring Boot"
  value       = [
    for ingress in aws_security_group.app_sg.ingress : {
      from_port   = ingress.from_port
      to_port     = ingress.to_port
      protocol    = ingress.protocol
      cidr_blocks = ingress.cidr_blocks
      description = ingress.description
    }
  ]
}

output "app_allowed_ports" {
  description = "Lista de portas abertas para a aplicação"
  value       = [
    for ingress in aws_security_group.app_sg.ingress : "${ingress.from_port}-${ingress.to_port}"
  ]
}

output "db_security_group_id" {
  description = "ID do security group do banco de dados"
  value       = aws_security_group.db_sg.id
}

output "db_security_group_name" {
  description = "Nome do security group do banco de dados"
  value       = aws_security_group.db_sg.name
}

output "db_security_group_ingress_rules" {
  description = "Regras de entrada configuradas para o banco de dados"
  value       = [
    for ingress in aws_security_group.db_sg.ingress : {
      from_port       = ingress.from_port
      to_port         = ingress.to_port
      protocol        = ingress.protocol
      security_groups = ingress.security_groups
      description     = ingress.description
    }
  ]
}

output "springboot_database_connection" {
  description = "Informação de conexão do banco de dados (Formato de conexão do Spring Boot)"
  value       = "spring.datasource.url=jdbc:mysql://YOUR_DB_ENDPOINT:3306/YOUR_DB_NAME"
  sensitive   = true
}

output "security_group_environment" {
  description = "Ambiente dos security groups"
  value       = var.sufixo
}