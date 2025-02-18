output "internet_gateway_id" {
  description = "ID do Internet Gateway (se criado)"
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway (se criado)"
  value       = length(aws_nat_gateway.this) > 0 ? aws_nat_gateway.this[0].id : null
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas criadas"
  value       = { for subnet in aws_subnet.this : subnet.tags.Name => subnet.id if subnet.map_public_ip_on_launch }
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas criadas"
  value       = { for subnet in aws_subnet.this : subnet.tags.Name => subnet.id if !subnet.map_public_ip_on_launch }
}
