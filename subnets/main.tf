############################################
# Criando as Subnets
############################################
resource "aws_subnet" "this" {
  for_each = { for s in var.subnets : s.name => s }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-${each.value.name}"
    "Type" = each.value.type
  })
}

############################################
# Criando Internet Gateway (Para Subnets Públicas)
############################################
resource "aws_internet_gateway" "this" {
  count  = length([for s in var.subnets : s if s.type == "public"]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-igw" })
}

############################################
# Criando Elastic IPs e NAT Gateways (Para cada AZ com Subnet Privada)
############################################
resource "aws_eip" "nat" {
  for_each = { for s in var.subnets : s.az => s if s.type == "private" }

  domain = "vpc"

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-eip-${each.key}" })
}

resource "aws_nat_gateway" "this" {
  for_each = aws_eip.nat

  allocation_id = each.value.id
  subnet_id     = aws_subnet.this["public-${each.key}"].id  # Associado à Subnet Pública correspondente

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-nat-${each.key}" })
}

############################################
# Criando Route Table Única para Subnets Públicas
############################################
resource "aws_route_table" "public" {
  count  = length([for s in var.subnets : s if s.type == "public"]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-public-rt" })
}

resource "aws_route" "public" {
  count = length(aws_route_table.public) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  for_each = { for s in var.subnets : s.name => s if s.type == "public" }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public[0].id
}

############################################
# Criando Route Tables Individuais para Subnets Privadas (1 por AZ)
############################################
resource "aws_route_table" "private" {
  for_each = { for s in var.subnets : s.az => s if s.type == "private" }

  vpc_id = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-private-rt-${each.key}" })
}

resource "aws_route" "private" {
  for_each = aws_route_table.private

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = { for s in var.subnets : s.name => s if s.type == "private" }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.private[each.value.az].id
}
