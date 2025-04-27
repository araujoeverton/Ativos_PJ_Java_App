# security_group.tf (atualizado para usar as variáveis)

resource "aws_security_group" "app_sg" {
  name        = "app-sg-homolog-${var.sufixo}"
  description = "Security group para aplicação Spring Boot Java"
  vpc_id      = aws_vpc.main.id

  # Permitir tráfego de entrada na porta do Spring Boot
  ingress {
    from_port   = var.spring_boot_port
    to_port     = var.spring_boot_port
    protocol    = "tcp"
    cidr_blocks = var.restrict_app_access ? [var.cidr_block_list[0]] : ["0.0.0.0/0"]
    description = "Acesso à API Spring Boot"
  }

  # Permitir tráfego HTTPS se habilitado
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

  # Porta de atuador
  ingress {
    from_port   = var.actuator_port
    to_port     = var.actuator_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_list[0]]  # Restrito à VPC
    description = "Porta do atuador Spring Boot"
  }

  # SSH para acesso de gerenciamento
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr_block]
    description = "SSH"
  }

  # Portas adicionais da aplicação
  dynamic "ingress" {
    for_each = var.additional_app_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.restrict_app_access ? [var.cidr_block_list[0]] : ["0.0.0.0/0"]
      description = "Porta adicional ${ingress.value}"
    }
  }

  # Permitir todo o tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permitir todo tráfego de saída"
  }

  tags = merge(
    {
      Name        = "sg-springboot-${var.sufixo}"
      Environment = var.sufixo
    },
    var.app_tags
  )
}

# Security group para banco de dados
resource "aws_security_group" "db_sg" {
  name        = "db-sg-${var.sufixo}"
  description = "Security group para banco de dados da aplicação Spring Boot"
  vpc_id      = aws_vpc.main.id

  # Permitir acesso ao banco de dados somente a partir do security group da aplicação
  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    description     = "Acesso ${var.db_engine} da aplicação"
  }

  # Permitir todo o tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permitir todo tráfego de saída"
  }

  tags = merge(
    {
      Name        = "sg-database-${var.sufixo}"
      Environment = var.sufixo
    },
    var.app_tags
  )
}