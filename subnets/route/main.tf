resource "aws_route_table" "this" {
  for_each = var.subnets

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.vpc_name}-rt-${each.key}"
  }
}

resource "aws_route" "public_routes" {
  for_each = { for k, v in var.subnets : k => v if contains(k, "public") }

  route_table_id         = aws_route_table.this[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route" "private_routes" {
  for_each = { for k, v in var.subnets : k => v if contains(k, "private") }

  route_table_id         = aws_route_table.this[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "this" {
  for_each = var.subnets

  subnet_id      = each.value
  route_table_id = aws_route_table.this[each.key].id
}
