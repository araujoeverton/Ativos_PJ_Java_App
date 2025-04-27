
# Criar a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block_list[0]
  enable_dns_support   = var.enable_dns_hostnames
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "vpc-homolog-${var.sufixo}"
  }
}

# Criar sub-rede pública
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_list[1]
  availability_zone       = var.az[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "subnet-publica-${var.sufixo}"
  }
}

# Criar sub-rede privada
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_list[2]
  availability_zone       = var.az[1]

  tags = {
    Name = "subnet-privada-${var.sufixo}"
  }
}

# Criar Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vpc-igw-${sufixo}"
  }
}

# Criar tabela de rotas para sub-rede pública
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

# Associar tabela de rotas à sub-rede pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Criar NAT Gateway (para permitir que recursos na sub-rede privada acessem a internet)
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

# Criar tabela de rotas para sub-rede privada
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

# Associar tabela de rotas à sub-rede privada
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}