variable "sufixo" {
  description = "Sufixo para identificar o ambiente (ex: dev, homolog, prod)"
  type        = string
}

variable "table_name" {
  description = "Nome base da tabela DynamoDB"
  type        = string
}

variable "billing_mode" {
  description = "Modo de cobrança (PROVISIONED ou PAY_PER_REQUEST)"
  type        = string
}

variable "hash_key" {
  description = "Atributo da chave de partição"
  type        = string
}

variable "hash_key_type" {
  description = "Tipo da chave de partição (S, N, ou B)"
  type        = string
}

variable "range_key" {
  description = "Atributo da chave de ordenação (opcional)"
  type        = string
  default     = null
}

variable "range_key_type" {
  description = "Tipo da chave de ordenação (S, N, ou B)"
  type        = string
  default     = null
}

variable "read_capacity" {
  description = "Unidades de capacidade de leitura (usado apenas se billing_mode for PROVISIONED)"
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "Unidades de capacidade de escrita (usado apenas se billing_mode for PROVISIONED)"
  type        = number
  default     = null
}

variable "additional_attributes" {
  description = "Atributos adicionais para índices secundários"
  type        = list(object({
    name = string
    type = string
  }))
  default     = []
}

variable "global_secondary_indexes" {
  description = "Configurações para índices secundários globais"
  type        = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    projection_type    = string
    non_key_attributes = optional(list(string))
    read_capacity      = optional(number)
    write_capacity     = optional(number)
  }))
  default     = []
}

variable "local_secondary_indexes" {
  description = "Configurações para índices secundários locais"
  type        = list(object({
    name               = string
    range_key          = string
    projection_type    = string
    non_key_attributes = optional(list(string))
  }))
  default     = []
}

variable "ttl_enabled" {
  description = "Habilitar Time to Live (TTL)"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "Nome do atributo para TTL"
  type        = string
  default     = null
}

variable "point_in_time_recovery_enabled" {
  description = "Habilitar recuperação point-in-time"
  type        = bool
  default     = false
}

variable "encryption_enabled" {
  description = "Habilitar criptografia do lado do servidor"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN da chave KMS para criptografia (opcional)"
  type        = string
  default     = null
}

variable "stream_enabled" {
  description = "Habilitar streams do DynamoDB"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Tipo de visualização do stream (NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES, KEYS_ONLY)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais para a tabela"
  type        = map(string)
  default     = {}
}