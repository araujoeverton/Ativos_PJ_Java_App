#==========================================
# Outputs para VPC
#==========================================
output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "Bloco CIDR da VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "ID da sub-rede pública"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID da sub-rede privada"
  value       = aws_subnet.private.id
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "nat_gateway_public_ip" {
  description = "IP público alocado para o NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "public_route_table_id" {
  description = "ID da tabela de rotas pública"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID da tabela de rotas privada"
  value       = aws_route_table.private.id
}

#==========================================
# Outputs para Security Groups
#==========================================
output "app_security_group_id" {
  description = "ID do security group da aplicação Spring Boot"
  value       = aws_security_group.app_sg.id
}

output "app_security_group_name" {
  description = "Nome do security group da aplicação"
  value       = aws_security_group.app_sg.name
}

output "db_security_group_id" {
  description = "ID do security group do banco de dados"
  value       = aws_security_group.db_sg.id
}

output "db_security_group_name" {
  description = "Nome do security group do banco de dados"
  value       = aws_security_group.db_sg.name
}

#==========================================
# Outputs para DynamoDB
#==========================================
output "dynamodb_table_id" {
  description = "ID da tabela DynamoDB"
  value       = aws_dynamodb_table.main.id
}

output "dynamodb_table_arn" {
  description = "ARN da tabela DynamoDB"
  value       = aws_dynamodb_table.main.arn
}

output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  value       = aws_dynamodb_table.main.name
}

output "dynamodb_table_hash_key" {
  description = "Nome da chave de partição"
  value       = aws_dynamodb_table.main.hash_key
}

output "dynamodb_table_range_key" {
  description = "Nome da chave de ordenação (se houver)"
  value       = aws_dynamodb_table.main.range_key
}

output "dynamodb_global_secondary_index_names" {
  description = "Nomes dos índices secundários globais"
  value       = [for i in aws_dynamodb_table.main.global_secondary_index : i.name]
}

output "dynamodb_local_secondary_index_names" {
  description = "Nomes dos índices secundários locais"
  value       = [for i in aws_dynamodb_table.main.local_secondary_index : i.name]
}

output "dynamodb_stream_arn" {
  description = "ARN do stream do DynamoDB (se habilitado)"
  value       = aws_dynamodb_table.main.stream_arn
}

#==========================================
# Outputs gerais do ambiente
#==========================================
output "environment" {
  description = "Nome do ambiente"
  value       = var.sufixo
}

output "infrastructure_summary" {
  description = "Resumo da infraestrutura criada"
  value       = <<EOF
Ambiente: ${var.sufixo}
VPC ID: ${aws_vpc.main.id}
Subnet Pública: ${aws_subnet.public.id} (${aws_subnet.public.cidr_block})
Subnet Privada: ${aws_subnet.private.id} (${aws_subnet.private.cidr_block})
Tabela DynamoDB: ${aws_dynamodb_table.main.name}
Security Group App: ${aws_security_group.app_sg.id}
Security Group DB: ${aws_security_group.db_sg.id}
EOF
}