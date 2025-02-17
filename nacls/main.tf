resource "aws_network_acl" "this" {
  for_each = { for nacl in var.nacls : nacl.name => nacl }

  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    "Name" = each.value.name
  })
}

resource "aws_network_acl_association" "this" {
  for_each = { for nacl in var.nacls : nacl.name => nacl if length(nacl.subnet_ids) > 0 }

  network_acl_id = aws_network_acl.this[each.key].id
  subnet_id      = each.value.subnet_ids[count.index]
}

resource "aws_network_acl_rule" "this" {
  for_each = { for nacl in var.nacls : nacl.name => nacl if length(nacl.rules) > 0 }

  network_acl_id = aws_network_acl.this[each.key].id
  rule_number    = each.value.rules[count.index].rule_number
  rule_action    = each.value.rules[count.index].rule_action
  protocol       = each.value.rules[count.index].protocol
  cidr_block     = each.value.rules[count.index].cidr_block
  from_port      = each.value.rules[count.index].from_port
  to_port        = each.value.rules[count.index].to_port
  egress         = each.value.rules[count.index].egress
}
