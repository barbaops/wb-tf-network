resource "aws_subnet" "this" {
  for_each = { for s in var.subnets : s.name => s }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-${each.value.name}"
    "Type" = each.value.type
  })
}

resource "aws_internet_gateway" "this" {
  count  = length([for s in var.subnets : s if s.type == "public"]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-igw" })
}

resource "aws_eip" "nat" {
  count  = length([for s in var.subnets : s if s.type == "private"]) > 0 ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  count         = length([for s in var.subnets : s if s.type == "private"]) > 0 ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.this["public-1a"].id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-nat" })
}

resource "aws_route_table" "public" {
  count  = length([for s in var.subnets : s if s.type == "public"]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-public-rt" })
}

resource "aws_route" "public" {
  count          = length(aws_route_table.public) > 0 ? 1 : 0
  route_table_id = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table" "private" {
  count  = length([for s in var.subnets : s if s.type == "private"]) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-private-rt" })
}

resource "aws_route" "private" {
  count          = length(aws_route_table.private) > 0 ? 1 : 0
  route_table_id = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this[0].id
}
