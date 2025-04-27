output "dynamodb_table_id" {
  description = "ID da tabela DynamoDB"
  value       = aws_dynamodb_table.dynamodb_table.id
}

output "dynamodb_table_arn" {
  description = "ARN da tabela DynamoDB"
  value       = aws_dynamodb_table.dynamodb_table.arn
}

output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  value       = aws_dynamodb_table.dynamodb_table.name
}

output "dynamodb_table_hash_key" {
  description = "Nome da chave de partição"
  value       = aws_dynamodb_table.dynamodb_table.hash_key
}

output "dynamodb_table_range_key" {
  description = "Nome da chave de ordenação (se houver)"
  value       = aws_dynamodb_table.dynamodb_table.range_key
}

output "dynamodb_global_secondary_index_names" {
  description = "Nomes dos índices secundários globais"
  value       = [for i in aws_dynamodb_table.dynamodb_table.global_secondary_index : i.name]
}

output "dynamodb_local_secondary_index_names" {
  description = "Nomes dos índices secundários locais"
  value       = [for i in aws_dynamodb_table.dynamodb_table.local_secondary_index : i.name]
}

output "dynamodb_stream_arn" {
  description = "ARN do stream do DynamoDB (se habilitado)"
  value       = aws_dynamodb_table.dynamodb_table.stream_arn
}

output "dynamodb_stream_label" {
  description = "Rótulo do stream do DynamoDB (se habilitado)"
  value       = aws_dynamodb_table.dynamodb_table.stream_label
}

output "dynamodb_billing_mode" {
  description = "Modo de cobrança configurado"
  value       = aws_dynamodb_table.dynamodb_table.billing_mode
}

output "dynamodb_environment" {
  description = "Ambiente da tabela DynamoDB"
  value       = var.sufixo
}