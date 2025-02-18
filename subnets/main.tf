resource "aws_subnet" "this" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = lookup(each.value, "public", false)

  tags = merge(var.tags, {
    "Name" = each.value.name
  })
}

resource "aws_eip" "nat" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.this[var.nat_subnet].id

  tags = merge(var.tags, {
    "Name" = "nat-gateway"
  })
}

resource "aws_route_table" "this" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if subnet.type == "private" }

  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    "Name" = "${each.key}-rt"
  })
}

resource "aws_route" "nat" {
  for_each = aws_route_table.this

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "this" {
  for_each = aws_route_table.this

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = each.value.id
}
