resource "aws_network_acl" "this" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { "Name" = "${var.nacl_name}" })
}

resource "aws_network_acl_rule" "ingress" {
  count = length(var.ingress_rules)

  network_acl_id = aws_network_acl.this.id
  rule_number    = var.ingress_rules[count.index]["rule_number"]
  protocol       = var.ingress_rules[count.index]["protocol"]
  rule_action    = var.ingress_rules[count.index]["rule_action"]
  cidr_block     = var.ingress_rules[count.index]["cidr_block"]
  from_port      = var.ingress_rules[count.index]["from_port"]
  to_port        = var.ingress_rules[count.index]["to_port"]
  egress         = false
}
