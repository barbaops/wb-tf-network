output "public_subnet_ids" {
  description = "IDs das subnets públicas criadas"
  value       = { for k, v in aws_subnet.this : k => v.id if v.map_public_ip_on_launch }
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas criadas"
  value       = { for k, v in aws_subnet.this : k => v.id if !v.map_public_ip_on_launch }
}

output "nat_gateway_ids" {
  description = "IDs dos NAT Gateways criados"
  value       = { for k, v in aws_nat_gateway.this : k => v.id }
}

output "public_route_table_id" {
  description = "ID da Route Table pública"
  value       = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : null
}

output "private_route_table_ids" {
  description = "IDs das Route Tables privadas por AZ"
  value       = { for k, v in aws_route_table.private : k => v.id }
}
