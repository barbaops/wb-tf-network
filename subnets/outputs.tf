output "public_subnet_ids" {
  description = "IDs das subnets públicas criadas"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas criadas"
  value       = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  description = "IDs das subnets criadas para banco de dados"
  value       = length(var.database_subnets) > 0 ? aws_subnet.database[*].id : []
}

output "pods_subnet_ids" {
  description = "IDs das subnets criadas para pods do EKS"
  value       = length(var.pods_subnets) > 0 ? aws_subnet.pods[*].id : []
}

output "private_subnet_cidrs" {
  description = "Lista de CIDRs das subnets privadas"
  value       = aws_subnet.private[*].cidr_block
}

output "database_subnet_cidrs" {
  description = "Lista de CIDRs das subnets de banco de dados"
  value       = length(var.database_subnets) > 0 ? aws_subnet.database[*].cidr_block : []
}

output "pods_subnet_cidrs" {
  description = "Lista de CIDRs das subnets de pods"
  value       = length(var.pods_subnets) > 0 ? aws_subnet.pods[*].cidr_block : []
}

output "nat_gateway_ids" {
  description = "IDs dos NAT Gateways criados"
  value       = length(var.private_subnets) > 0 ? aws_nat_gateway.this[*].id : []
}

output "private_route_table_ids" {
  description = "IDs das tabelas de rotas das subnets privadas"
  value       = aws_route_table.private[*].id
}
