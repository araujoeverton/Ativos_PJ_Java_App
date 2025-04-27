# Variáveis gerais
variable "sufixo" {
  description = "Sufixo para identificar o ambiente (ex: dev, homolog, prod)"
  type        = string
}

#==========================================
# Variáveis para VPC
#==========================================
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

#==========================================
# Variáveis para Security Groups
#==========================================
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
  description = "Tags específicas para recursos da aplicação"
  type        = map(string)
}

#==========================================
# Variáveis para DynamoDB
#==========================================
variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  type        = string
}

variable "dynamodb_billing_mode" {
  description = "Modo de cobrança (PROVISIONED ou PAY_PER_REQUEST)"
  type        = string
}

variable "dynamodb_hash_key" {
  description = "Atributo da chave de partição"
  type        = string
}

variable "dynamodb_hash_key_type" {
  description = "Tipo da chave de partição (S, N, ou B)"
  type        = string
}

variable "dynamodb_range_key" {
  description = "Atributo da chave de ordenação (opcional)"
  type        = string
}

variable "dynamodb_range_key_type" {
  description = "Tipo da chave de ordenação (S, N, ou B)"
  type        = string
}

variable "dynamodb_ttl_enabled" {
  description = "Habilitar Time to Live (TTL)"
  type        = bool
}

variable "dynamodb_ttl_attribute_name" {
  description = "Nome do atributo para TTL"
  type        = string
}

variable "dynamodb_point_in_time_recovery_enabled" {
  description = "Habilitar recuperação point-in-time"
  type        = bool
}

variable "dynamodb_encryption_enabled" {
  description = "Habilitar criptografia do lado do servidor"
  type        = bool
}

variable "dynamodb_stream_enabled" {
  description = "Habilitar streams do DynamoDB"
  type        = bool
}

variable "dynamodb_stream_view_type" {
  description = "Tipo de visualização do stream (NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES, KEYS_ONLY)"
  type        = string
}

variable "dynamodb_additional_attributes" {
  description = "Atributos adicionais para índices secundários"
  type        = list(object({
    name = string
    type = string
  }))
}

variable "dynamodb_global_secondary_indexes" {
  description = "Configurações para índices secundários globais"
  type        = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    projection_type    = string
    non_key_attributes = optional(list(string))
  }))
}

variable "dynamodb_local_secondary_indexes" {
  description = "Configurações para índices secundários locais"
  type        = list(object({
    name               = string
    range_key          = string
    projection_type    = string
    non_key_attributes = optional(list(string))
  }))
}

variable "dynamodb_tags" {
  description = "Tags para a tabela DynamoDB"
  type        = map(string)
}

#==========================================
# Variáveis para Spring Boot App
#==========================================
variable "app_instance_type" {
  description = "Tipo de instância para a aplicação"
  type        = string
}

variable "app_min_size" {
  description = "Número mínimo de instâncias"
  type        = number
}

variable "app_max_size" {
  description = "Número máximo de instâncias"
  type        = number
}

variable "app_desired_capacity" {
  description = "Capacidade desejada de instâncias"
  type        = number
}

variable "app_health_check_path" {
  description = "Caminho para health check da aplicação"
  type        = string
}

variable "app_health_check_grace_period" {
  description = "Período de carência para health checks em segundos"
  type        = number
}

variable "app_enable_auto_scaling" {
  description = "Habilitar auto scaling para a aplicação"
  type        = bool
}

variable "app_auto_scaling_target_cpu" {
  description = "Utilização de CPU alvo para auto scaling"
  type        = number
}

variable "app_auto_scaling_target_memory" {
  description = "Utilização de memória alvo para auto scaling"
  type        = number
}

variable "app_java_opts" {
  description = "Opções da JVM para a aplicação Java"
  type        = string
}

variable "app_spring_profiles" {
  description = "Perfis Spring ativos"
  type        = string
}

variable "app_log_level" {
  description = "Nível de log da aplicação"
  type        = string
}

variable "app_enable_distributed_tracing" {
  description = "Habilitar rastreamento distribuído"
  type        = bool
}

variable "app_db_connection_url" {
  description = "URL de conexão com o banco de dados"
  type        = string
}

variable "app_db_connection_username" {
  description = "Nome de usuário para conexão com o banco de dados"
  type        = string
}

variable "app_enable_cache" {
  description = "Habilitar cache na aplicação"
  type        = bool
}

variable "app_enable_circuit_breaker" {
  description = "Habilitar circuit breaker na aplicação"
  type        = bool
}