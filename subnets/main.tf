resource "aws_subnet" "this" {
  count = length(var.subnets)

  vpc_id                  = var.vpc_id
  cidr_block              = var.subnets[count.index]["cidr"]
  availability_zone       = var.subnets[count.index]["az"]
  map_public_ip_on_launch = lookup(var.subnets[count.index], "public", false)

  tags = merge(var.tags, {
    "Name"  = "${var.vpc_name}-${var.subnets[count.index]["name"]}"
    "Type"  = var.subnets[count.index]["type"]
  })
}
