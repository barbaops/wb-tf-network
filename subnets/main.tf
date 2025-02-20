
# 🚀 Criando subnets públicas
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${each.key}"
    Type = "public"
  }
}

# 🚀 Criando subnets privadas
resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.vpc_name}-private-${each.key}"
    Type = "private"
  }
}

# 🚀 Criando subnets de banco de dados
resource "aws_subnet" "database" {
  for_each = var.database_subnets

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.vpc_name}-database-${each.key}"
    Type = "database"
  }
}

# 🚀 Criando Internet Gateway
resource "aws_internet_gateway" "this" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = { Name = "${var.vpc_name}-igw" }
}

# 🚀 Criando Elastic IPs para NAT Gateway
resource "aws_eip" "nat" {
  for_each = var.private_subnets
  domain   = "vpc"
}

# 🚀 Criando NAT Gateway por AZ
resource "aws_nat_gateway" "this" {
  for_each      = var.private_subnets
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.value.az].id  # 🚀 Pegando a subnet pública correta para a AZ

  tags = { Name = "${var.vpc_name}-nat-${each.key}" }
}

# 🚀 Criando Route Table Pública
resource "aws_route_table" "public" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = { Name = "${var.vpc_name}-public-rt" }
}

# 🚀 Adicionando rota para IGW na RT Pública
resource "aws_route" "public" {
  count                 = length(aws_route_table.public) > 0 ? 1 : 0
  route_table_id        = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id            = aws_internet_gateway.this[0].id
}

# 🚀 Criando Route Table Privada por AZ
resource "aws_route_table" "private" {
  for_each = var.private_subnets
  vpc_id   = var.vpc_id

  tags = { Name = "${var.vpc_name}-private-rt-${each.key}" }
}

# 🚀 Criando Route Table de Database (compartilhada)
resource "aws_route_table" "database" {
  count  = length(var.database_subnets) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = { Name = "${var.vpc_name}-database-rt" }
}

# 🚀 Criando Rotas nas RTs Privadas para o NAT Gateway
resource "aws_route" "private" {
  for_each       = aws_route_table.private
  route_table_id = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this[each.key].id
}

# 🚀 Criando associação das subnets públicas à RT pública
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

# 🚀 Criando associação das subnets privadas às RTs privadas
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

# 🚀 Criando associação das subnets de banco de dados à RT de database
resource "aws_route_table_association" "database" {
  for_each       = aws_subnet.database
  subnet_id      = each.value.id
  route_table_id = aws_route_table.database[0].id
}
