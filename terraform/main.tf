# PROVEDOR AWS
provider "aws" {
  region = "us-east-1"
}

#==========================================
# VPC
#==========================================
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block_list[0]
  enable_dns_support   = var.enable_dns_hostnames
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "vpc-${var.sufixo}"
  }
}

# Subnet pública
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_list[1]
  availability_zone       = var.az[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "subnet-publica-${var.sufixo}"
  }
}

# Subnet privada
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_list[2]
  availability_zone       = var.az[1]

  tags = {
    Name = "subnet-privada-${var.sufixo}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vpc-igw-${var.sufixo}"
  }
}

# Tabela de rotas para subnet pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_block_list[3]
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-publica-${var.sufixo}"
  }
}

# Associar tabela de rotas à subnet pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "vpc-nat-${var.sufixo}"
  }
}

# Tabela de rotas para subnet privada
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = var.cidr_block_list[3]
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "rt-privada-${var.sufixo}"
  }
}

# Associar tabela de rotas à subnet privada
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

#==========================================
# SECURITY GROUPS
#==========================================
# Security Group para a aplicação Spring Boot
resource "aws_security_group" "app_sg" {
  name        = "app-sg-${var.sufixo}"
  description = "Security group para aplicacao Spring Boot Java"
  vpc_id      = aws_vpc.main.id

  # Spring Boot Port
  ingress {
    from_port   = var.spring_boot_port
    to_port     = var.spring_boot_port
    protocol    = "tcp"
    cidr_blocks = var.restrict_app_access ? [var.cidr_block_list[0]] : ["0.0.0.0/0"]
    description = "Acesso a API Spring Boot"
  }

  # HTTPS (se habilitado)
  dynamic "ingress" {
    for_each = var.https_enabled ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.restrict_app_access ? [var.cidr_block_list[0]] : ["0.0.0.0/0"]
      description = "Acesso HTTPS"
    }
  }

  # Porta do Actuator
  ingress {
    from_port   = var.actuator_port
    to_port     = var.actuator_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_list[0]]
    description = "Porta do atuador Spring Boot"
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr_block]
    description = "SSH"
  }

  # Portas adicionais
  dynamic "ingress" {
    for_each = var.additional_app_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.restrict_app_access ? [var.cidr_block_list[0]] : ["0.0.0.0/0"]
      description = "Porta adicional"
    }
  }

  # Tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Porta de saida"
  }

  tags = merge(
    {
      Name        = "sg-springboot-${var.sufixo}"
      Environment = var.sufixo
    },
    var.app_tags
  )
}

# Security Group para banco de dados
resource "aws_security_group" "db_sg" {
  name        = "db-sg-${var.sufixo}"
  description = "Security group para banco de dados da aplicacao Spring Boot"
  vpc_id      = aws_vpc.main.id

  # Acesso ao banco de dados
  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    description     = "Acesso tcp da aplicacao"
  }

  # Tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Trafego de saida"
  }

  tags = merge(
    {
      Name        = "sg-database-${var.sufixo}"
      Environment = var.sufixo
    },
    var.app_tags
  )
}

#==========================================
# DYNAMODB
#==========================================
resource "aws_dynamodb_table" "main" {
  name           = "${var.dynamodb_table_name}-${var.sufixo}"
  billing_mode   = var.dynamodb_billing_mode
  hash_key       = var.dynamodb_hash_key
  range_key      = var.dynamodb_range_key

  # Chave primária
  attribute {
    name = var.dynamodb_hash_key
    type = var.dynamodb_hash_key_type
  }

  # Chave de ordenação (se definida)
  dynamic "attribute" {
    for_each = var.dynamodb_range_key != null ? [1] : []
    content {
      name = var.dynamodb_range_key
      type = var.dynamodb_range_key_type
    }
  }

  # Atributos adicionais para índices secundários
  dynamic "attribute" {
    for_each = var.dynamodb_additional_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # Atributo "createDate" necessário para os índices
  attribute {
    name = "createDate"
    type = "S"  # Assumindo que createDate é uma string
  }

  # Índices secundários globais
  dynamic "global_secondary_index" {
    for_each = var.dynamodb_global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      
      read_capacity  = var.dynamodb_billing_mode == "PROVISIONED" ? 5 : null
      write_capacity = var.dynamodb_billing_mode == "PROVISIONED" ? 5 : null
    }
  }

  # Índices secundários locais
  dynamic "local_secondary_index" {
    for_each = var.dynamodb_local_secondary_indexes
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }

  # Configurações TTL
  dynamic "ttl" {
    for_each = var.dynamodb_ttl_enabled ? [1] : []
    content {
      attribute_name = var.dynamodb_ttl_attribute_name
      enabled        = true
    }
  }

  # Configurações de backup
  point_in_time_recovery {
    enabled = var.dynamodb_point_in_time_recovery_enabled
  }

  # Configurações de criptografia
  server_side_encryption {
    enabled = var.dynamodb_encryption_enabled
  }

  # Configuração de stream
  stream_enabled   = var.dynamodb_stream_enabled
  stream_view_type = var.dynamodb_stream_enabled ? var.dynamodb_stream_view_type : null

  tags = merge(
    {
      Name        = "${var.dynamodb_table_name}-${var.sufixo}"
      Environment = var.sufixo
    },
    var.dynamodb_tags
  )
}

#==========================================
# APLICAÇÃO SPRING BOOT (placeholder)
#==========================================
# Aqui poderá ser adicionado recursos para a aplicação Spring Boot
# como instâncias EC2, Auto Scaling Group, Load Balancer, etc.
# Utilizar as variáveis app_* para configurá-los.

# Exemplo de comentário para implementação futura:
# Para uma aplicação Spring Boot, poderá considerar:
# 1. Launch Template ou Launch Configuration
# 2. Auto Scaling Group
# 3. Load Balancer e Target Group
# 4. IAM Roles e Policies necessárias
# 5. CloudWatch Alarms para monitoramento
# 6. Configurações de deployment (CodeDeploy)

