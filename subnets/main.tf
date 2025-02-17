resource "aws_subnet" "this" {
  count = length(var.subnets)

  vpc_id                  = var.vpc_id
  cidr_block              = var.subnets[count.index]["cidr"]
  availability_zone       = var.subnets[count.index]["az"]
  map_public_ip_on_launch = lookup(var.subnets[count.index], "public", false)

  tags = merge(var.tags, {
    "Name"  = "${var.vpc_name}-${var.subnets[count.index]["name"]}"
    "Type"  = lookup(var.subnets[count.index], "public", false) ? "public" : "private"
  })
}

# 🔹 Criar Internet Gateway se houver ao menos 1 subnet pública
resource "aws_internet_gateway" "this" {
  count  = length([for subnet in var.subnets : subnet if lookup(subnet, "public", false)]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-igw"
  })
}

# 🔹 Criar Tabela de Rotas Pública se houver subnets públicas
resource "aws_route_table" "public" {
  count  = length([for subnet in var.subnets : subnet if lookup(subnet, "public", false)]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-public-rt"
  })
}

# 🔹 Associar Subnets Públicas à Tabela de Rotas Pública
resource "aws_route_table_association" "public" {
  count = length([for subnet in var.subnets : subnet if lookup(subnet, "public", false)])

  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.public[0].id
}
