resource "aws_network_acl" "this" {
  for_each = { for nacl in var.nacls : nacl.name => nacl }

  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-${each.value.name}-nacl"
  })
}

# 🔹 Criando regras de entrada
resource "aws_network_acl_rule" "ingress" {
  for_each = { for nacl in var.nacls : nacl.name => nacl if length(nacl.ingress_rules) > 0 }

  network_acl_id = aws_network_acl.this[each.key].id
  rule_number    = each.value.ingress_rules[0].rule_number
  protocol       = each.value.ingress_rules[0].protocol
  action         = each.value.ingress_rules[0].action
  cidr_block     = each.value.ingress_rules[0].cidr_block
  from_port      = each.value.ingress_rules[0].from_port
  to_port        = each.value.ingress_rules[0].to_port
  egress         = false
}

# 🔹 Criando regras de saída
resource "aws_network_acl_rule" "egress" {
  for_each = { for nacl in var.nacls : nacl.name => nacl if length(nacl.egress_rules) > 0 }

  network_acl_id = aws_network_acl.this[each.key].id
  rule_number    = each.value.egress_rules[0].rule_number
  protocol       = each.value.egress_rules[0].protocol
  action         = each.value.egress_rules[0].action
  cidr_block     = each.value.egress_rules[0].cidr_block
  from_port      = each.value.egress_rules[0].from_port
  to_port        = each.value.egress_rules[0].to_port
  egress         = true
}

# 🔹 Associando as NACLs às Subnets
resource "aws_network_acl_association" "this" {
  for_each = { for nacl in var.nacls : nacl.name => nacl if length(nacl.subnet_ids) > 0 }

  network_acl_id = aws_network_acl.this[each.key].id
  subnet_id      = each.value.subnet_ids[0]
}
