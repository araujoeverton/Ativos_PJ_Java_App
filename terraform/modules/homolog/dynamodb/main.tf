resource "aws_dynamodb_table" "dynamodb_table" {
  name           = "${var.table_name}-${var.sufixo}"
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  range_key      = var.range_key

  # Chave primária
  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  # Chave de ordenação (se definida)
  dynamic "attribute" {
    for_each = var.range_key != null ? [1] : []
    content {
      name = var.range_key
      type = var.range_key_type
    }
  }

  # Atributos adicionais para índices secundários
  dynamic "attribute" {
    for_each = var.additional_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # Configuração para Provisioned Capacity
  dynamic "read_capacity" {
    for_each = var.billing_mode == "PROVISIONED" ? [1] : []
    content {
      read_capacity  = var.read_capacity
    }
  }

  dynamic "write_capacity" {
    for_each = var.billing_mode == "PROVISIONED" ? [1] : []
    content {
      write_capacity = var.write_capacity
    }
  }

  # Índices secundários globais
  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      
      # Capacidade para GSIs (se PROVISIONED)
      dynamic "read_capacity" {
        for_each = var.billing_mode == "PROVISIONED" ? [1] : []
        content {
          read_capacity  = lookup(global_secondary_index.value, "read_capacity", var.read_capacity)
        }
      }
      
      dynamic "write_capacity" {
        for_each = var.billing_mode == "PROVISIONED" ? [1] : []
        content {
          write_capacity = lookup(global_secondary_index.value, "write_capacity", var.write_capacity)
        }
      }
    }
  }

  # Índices secundários locais
  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }

  # Configurações TTL
  dynamic "ttl" {
    for_each = var.ttl_enabled ? [1] : []
    content {
      attribute_name = var.ttl_attribute_name
      enabled        = true
    }
  }

  # Configurações de backup
  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  # Configurações de criptografia
  server_side_encryption {
    enabled     = var.encryption_enabled
    kms_key_arn = var.kms_key_arn
  }

  # Configuração de stream
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_enabled ? var.stream_view_type : null

  tags = merge(
    {
      Name        = "${var.table_name}-${var.sufixo}"
      Environment = var.sufixo
    },
    var.tags
  )
}