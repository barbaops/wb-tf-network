resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnets[count.index].cidr
  availability_zone       = var.public_subnets[count.index].az
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    "Name" = format("%s-public-%s", var.vpc_name, var.public_subnets[count.index].az)
  })
}

resource "aws_eip" "nat" {
  count  = length(var.public_subnets) > 0 && length(var.private_subnets) > 0 ? length(var.public_subnets) : 0
  domain = "vpc"

  tags = merge(var.tags, {
    "Name" = format("%s-nat-eip-%s", var.vpc_name, var.public_subnets[count.index].az)
  })
}

resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnets) > 0 && length(var.private_subnets) > 0 ? length(var.public_subnets) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.tags, {
    "Name" = format("%s-natgw-%s", var.vpc_name, var.public_subnets[count.index].az)
  })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnets[count.index].cidr
  availability_zone       = var.private_subnets[count.index].az
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    "Name" = format("%s-private-%s", var.vpc_name, var.private_subnets[count.index].az)
  })
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    "Name" = format("%s-private-rt-%s", var.vpc_name, var.private_subnets[count.index].az)
  })
}

resource "aws_route" "private" {
  count = length(var.private_subnets) > 0 && length(var.public_subnets) > 0 ? length(var.private_subnets) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_nat_gateway.this[
    index(var.public_subnets[*].az, var.private_subnets[count.index].az)
  ].id
}

resource "aws_subnet" "database" {
  count = length(var.database_subnets)

  vpc_id                  = var.vpc_id
  cidr_block              = var.database_subnets[count.index].cidr
  availability_zone       = var.database_subnets[count.index].az
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    "Name" = format("%s-db-%s", var.vpc_name, var.database_subnets[count.index].az)
  })
}

resource "aws_subnet" "pods" {
  count = length(var.pods_subnets)

  vpc_id                  = var.vpc_id
  cidr_block              = var.pods_subnets[count.index].cidr
  availability_zone       = var.pods_subnets[count.index].az
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    "Name" = format("%s-pods-%s", var.vpc_name, var.pods_subnets[count.index].az)
  })
}
