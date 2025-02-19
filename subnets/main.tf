resource "aws_subnet" "this" {
  for_each = { for s in var.subnets : "${s.type}-${s.az}" => s }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-${each.value.name}"
    "Type" = each.value.type
  })
}

# 📌 Internet Gateway - Apenas para Subnets Públicas
resource "aws_internet_gateway" "this" {
  count  = length([for s in var.subnets : s if s.type == "public"]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-igw" })
}

# 📌 Elastic IP para NAT Gateway - Um por AZ onde há Private Subnets
resource "aws_eip" "nat" {
  for_each = { for s in var.subnets : s.az => s if s.type == "private" }

  domain = "vpc"
}

# 📌 NAT Gateway - Um por AZ onde há Private Subnets
resource "aws_nat_gateway" "this" {
  for_each = { for s in var.subnets : s.az => s if s.type == "private" }

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.this["public-${each.key}"].id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-nat-${each.key}" })
}

# 📌 Route Table para Subnets Públicas (Compartilhada)
resource "aws_route_table" "public" {
  count  = length([for s in var.subnets : s if s.type == "public"]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-public-access" })
}

# 📌 Rota para Internet Gateway (Público)
resource "aws_route" "public" {
  count          = length(aws_route_table.public) > 0 ? 1 : 0
  route_table_id = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

# 📌 Associação de Subnet Pública à Route Table Pública
resource "aws_route_table_association" "public" {
  for_each = { for s in var.subnets : s.name => s if s.type == "public" }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public[0].id
}

# 📌 Route Table para cada AZ com Subnet Privada
resource "aws_route_table" "private" {
  for_each = { for s in var.subnets : s.az => s if s.type == "private" }
  vpc_id   = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-private-${each.key}" })
}

# 📌 Rota da Subnet Privada para NAT Gateway correspondente
resource "aws_route" "private" {
  for_each = aws_route_table.private

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this[each.key].id
}

# 📌 Associação de Subnet Privada à sua Route Table Privada
resource "aws_route_table_association" "private" {
  for_each = { for s in var.subnets : s.name => s if s.type == "private" }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.private[each.value.az].id
}

# 📌 Route Table para Database (Opcional)
resource "aws_route_table" "database" {
  count  = length([for s in var.subnets : s if s.type == "database"]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-database" })
}

resource "aws_route_table_association" "database" {
  for_each = { for s in var.subnets : s.name => s if s.type == "database" }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.database[0].id
}

# 📌 Route Table para Pods (Opcional)
resource "aws_route_table" "pods" {
  count  = length([for s in var.subnets : s if s.type == "pods"]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-pods" })
}

resource "aws_route_table_association" "pods" {
  for_each = { for s in var.subnets : s.name => s if s.type == "pods" }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.pods[0].id
}
