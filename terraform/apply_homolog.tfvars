# homolog.tfvars - Arquivo único para todas as configurações do ambiente de homologação

# Sufixo comum para todos os recursos
sufixo = "homolog"

# Configurações de VPC
cidr_block_list        = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24", "0.0.0.0/0"]
az                     = ["us-east-1a", "us-east-1b"]
enable_dns_hostnames   = true
map_public_ip_on_launch = true

# Configurações de Security Group
admin_cidr_block       = "10.0.0.0/8"
spring_boot_port       = 8080
actuator_port          = 8081
db_port                = 3306
db_engine              = "mysql"
restrict_app_access    = false
https_enabled          = true
additional_app_ports   = [9090]
app_tags               = {
  Application = "java-spring-boot"
  ManagedBy   = "Terraform"
  Team        = "BackendTeam"
}

# Configurações DynamoDB
dynamodb_table_name                     = "minha-aplicacao"
dynamodb_billing_mode                   = "PAY_PER_REQUEST"
dynamodb_hash_key                       = "id"
dynamodb_hash_key_type                  = "S"
dynamodb_range_key                      = "sort_key"
dynamodb_range_key_type                 = "S"
dynamodb_ttl_enabled                    = true
dynamodb_ttl_attribute_name             = "expiryDate"
dynamodb_point_in_time_recovery_enabled = false
dynamodb_encryption_enabled             = true
dynamodb_stream_enabled                 = true
dynamodb_stream_view_type               = "NEW_AND_OLD_IMAGES"

dynamodb_additional_attributes = [
  {
    name = "email"
    type = "S"
  },
  {
    name = "status"
    type = "S"
  }
]

dynamodb_global_secondary_indexes = [
  {
    name            = "EmailIndex"
    hash_key        = "email"
    projection_type = "ALL"
  },
  {
    name            = "StatusIndex"
    hash_key        = "status"
    range_key       = "id"
    projection_type = "INCLUDE"
    non_key_attributes = ["createDate", "lastUpdateDate"]
  }
]

dynamodb_local_secondary_indexes = [
  {
    name            = "CreateDateIndex"
    range_key       = "createDate"
    projection_type = "ALL"
  }
]

dynamodb_tags = {
  Project     = "MinhaAplicacao"
  ManagedBy   = "Terraform"
  Owner       = "DevTeam"
  Environment = "Homolog"
}

# Configurações da aplicação Spring Boot
app_instance_type                      = "t3.small"
app_min_size                           = 1
app_max_size                           = 2
app_desired_capacity                   = 1
app_health_check_path                  = "/actuator/health"
app_health_check_grace_period          = 300
app_enable_auto_scaling                = true
app_auto_scaling_target_cpu            = 70
app_auto_scaling_target_memory         = 80
app_java_opts                          = "-Xms512m -Xmx1024m"
app_spring_profiles                    = "homolog"
app_log_level                          = "INFO"
app_enable_distributed_tracing         = true
app_db_connection_url                  = "jdbc:mysql://db-homolog.internal:3306/appdb"
app_db_connection_username             = "app_user"
app_enable_cache                       = true
app_enable_circuit_breaker             = true