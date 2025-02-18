resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = merge(var.tags, {
    "Name" = var.vpc_name
  })
}

resource "aws_vpc_ipv4_cidr_block_association" "additional" {
  count      = var.additional_cidr_block != null ? 1 : 0
  vpc_id     = aws_vpc.this.id
  cidr_block = var.additional_cidr_block
}
