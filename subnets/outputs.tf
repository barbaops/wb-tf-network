output "internet_gateway_id" {
  description = "ID do Internet Gateway (se criado)"
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}

output "public_route_table_id" {
  description = "ID da Tabela de Rotas Pública (se criada)"
  value       = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : null
}

output "subnet_ids" {
  description = "Lista de IDs das subnets criadas"
  value       = { for k, v in aws_subnet.this : k => v.id }
}
