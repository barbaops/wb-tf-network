resource "aws_subnet" "public" {
  for_each = toset(var.subnet_azs)

  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, index(var.subnet_azs, each.key))
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${each.key}"
    Type = "public"
  }
}

resource "aws_subnet" "private" {
  for_each = toset(var.subnet_azs)

  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, index(var.subnet_azs, each.key) + 10)
  availability_zone = each.key

  tags = {
    Name = "${var.vpc_name}-private-${each.key}"
    Type = "private"
  }
}

resource "aws_subnet" "database" {
  for_each = toset(var.subnet_azs)

  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, index(var.subnet_azs, each.key) + 20)
  availability_zone = each.key

  tags = {
    Name = "${var.vpc_name}-database-${each.key}"
    Type = "database"
  }
}

resource "aws_internet_gateway" "this" {
  count  = length(var.subnet_azs) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = { Name = "${var.vpc_name}-igw" }
}

resource "aws_eip" "nat" {
  for_each = toset(var.subnet_azs)
  domain   = "vpc"
}

resource "aws_nat_gateway" "this" {
  for_each      = toset(var.subnet_azs)
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = { Name = "${var.vpc_name}-nat-${each.key}" }
}

resource "aws_route_table" "public" {
  count  = length(var.subnet_azs) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = { Name = "${var.vpc_name}-public-rt" }
}

resource "aws_route" "public" {
  count                 = length(aws_route_table.public) > 0 ? 1 : 0
  route_table_id        = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id            = aws_internet_gateway.this[0].id
}

resource "aws_route_table" "private" {
  for_each = toset(var.subnet_azs)
  vpc_id   = var.vpc_id

  tags = { Name = "${var.vpc_name}-private-rt-${each.key}" }
}

resource "aws_route_table" "database" {
  count  = length(var.subnet_azs) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = { Name = "${var.vpc_name}-database-rt" }
}

resource "aws_route" "private" {
  for_each       = aws_route_table.private
  route_table_id = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "database" {
  for_each       = aws_subnet.database
  subnet_id      = each.value.id
  route_table_id = aws_route_table.database[0].id
}

