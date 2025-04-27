variable "sufixo" {
    description = "Nome padrão do recurso"
    type = string
}

variable "az" {
    description = "Zonas de disponibilidade"
    type = list(string)
    default = ["us-east-1a", "us-east-1b"]
  
}
variable "map_public_ip_on_launch" {
    description = "Mapeamento de IP publico"
    type = bool
  
}
variable "cidr_block_list" {
    description = "Bloco CIDR da VPC"
    type = list(string)
}
variable "enable_dns_support" {
    description = "Liberação de suporte DNS"
    type = bool
}
  
variable "enable_dns_hostnames" {
    description = "Liberação de DNS hostnames"
    type = bool
}

