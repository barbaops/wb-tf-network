output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = { for s in aws_subnet.this : s.tags.Name => s.id if s.map_public_ip_on_launch }
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = { for s in aws_subnet.this : s.tags.Name => s.id if s.tags.Type == "private" }
}

output "database_subnet_ids" {
  description = "IDs das subnets de banco de dados"
  value       = { for s in aws_subnet.this : s.tags.Name => s.id if s.tags.Type == "database" }
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway (se criado)"
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway (se criado)"
  value       = length(aws_nat_gateway.this) > 0 ? aws_nat_gateway.this[0].id : null
}
