output "subnet_ids" {
  description = "IDs das subnets criadas"
  value       = aws_subnet.this[*].id
}

output "private_subnet_cidrs" {
  description = "Lista de CIDRs das subnets privadas"
  value       = aws_subnet.private[*].cidr_block
}
