# outputs.tf

output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "Bloco CIDR da VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_name" {
  description = "Nome da VPC criada"
  value       = aws_vpc.main.tags.Name
}

output "public_subnet_id" {
  description = "ID da sub-rede pública"
  value       = aws_subnet.public.id
}

output "public_subnet_cidr" {
  description = "Bloco CIDR da sub-rede pública"
  value       = aws_subnet.public.cidr_block
}

output "public_subnet_az" {
  description = "Zona de disponibilidade da sub-rede pública"
  value       = aws_subnet.public.availability_zone
}

output "private_subnet_id" {
  description = "ID da sub-rede privada"
  value       = aws_subnet.private.id
}

output "private_subnet_cidr" {
  description = "Bloco CIDR da sub-rede privada"
  value       = aws_subnet.private.cidr_block
}

output "private_subnet_az" {
  description = "Zona de disponibilidade da sub-rede privada"
  value       = aws_subnet.private.availability_zone
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "nat_public_ip" {
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

output "sufixo_ambiente" {
  description = "Sufixo usado para nomear os recursos"
  value       = var.sufixo
}

output "cidr_blocks" {
  description = "Lista de blocos CIDR usados na configuração"
  value       = var.cidr_block_list
}

output "availability_zones" {
  description = "Zonas de disponibilidade usadas na configuração"
  value       = var.az
}