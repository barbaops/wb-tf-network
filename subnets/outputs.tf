output "subnet_ids" {
  description = "IDs das subnets criadas"
  value       = aws_subnet.this[*].id
}

output "private_subnet_cidrs" {
  description = "Lista de CIDRs das subnets privadas"
  value       = [for subnet in aws_subnet.this : subnet.cidr_block if lookup(subnet.tags, "Type", "private") == "private"]
}
