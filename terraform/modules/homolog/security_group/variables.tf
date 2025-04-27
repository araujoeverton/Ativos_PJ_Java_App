variable "sufixo" {
  description = "Sufixo para identificar o ambiente (ex: dev, homolog, prod)"
  type        = string
}

variable "cidr_block_list" {
  description = "Lista de blocos CIDR [VPC, Subnet pública, Subnet privada, Rota padrão]"
  type        = list(string)
}

variable "az" {
  description = "Lista de zonas de disponibilidade"
  type        = list(string)
}

variable "enable_dns_hostnames" {
  description = "Habilitar hostnames DNS na VPC"
  type        = bool
}

variable "map_public_ip_on_launch" {
  description = "Atribuir IP público automaticamente às instâncias na subnet pública"
  type        = bool
}

# Variáveis específicas para Security Group

variable "admin_cidr_block" {
  description = "Bloco CIDR para acesso administrativo SSH"
  type        = string
}

variable "spring_boot_port" {
  description = "Porta para a aplicação Spring Boot"
  type        = number
}

variable "actuator_port" {
  description = "Porta para o atuador Spring Boot"
  type        = number
}

variable "db_port" {
  description = "Porta para o banco de dados"
  type        = number
}

variable "db_engine" {
  description = "Tipo de banco de dados"
  type        = string
}

variable "restrict_app_access" {
  description = "Restringir acesso à aplicação (false = acessível de qualquer lugar, true = restrito à VPC)"
  type        = bool
}

variable "https_enabled" {
  description = "Habilitar acesso HTTPS"
  type        = bool
}

variable "additional_app_ports" {
  description = "Portas adicionais para a aplicação Spring Boot"
  type        = list(number)
}

variable "app_tags" {
  description = "Tags adicionais para recursos da aplicação"
  type        = map(string)
}