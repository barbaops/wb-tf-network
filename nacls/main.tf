# 🔹 IDs das subnets públicas
output "public_subnet_ids" {
  description = "IDs das subnets públicas criadas"
  value       = aws_subnet.public[*].id
}

# 🔹 IDs das subnets privadas
output "private_subnet_ids" {
  description = "IDs das subnets privadas criadas"
  value       = aws_subnet.private[*].id
}

# 🔹 IDs das subnets de banco de dados
output "database_subnet_ids" {
  description = "IDs das subnets criadas para banco de dados"
  value       = length(var.database_subnets) > 0 ? aws_subnet.database[*].id : []
}

# 🔹 IDs das subnets de pods
output "pods_subnet_ids" {
  description = "IDs das subnets criadas para pods do EKS"
  value       = length(var.pods_subnets) > 0 ? aws_subnet.pods[*].id : []
}

# 🔹 CIDR das subnets privadas (para regras de segurança)
output "private_subnet_cidrs" {
  description = "Lista de CIDRs das subnets privadas"
  value       = aws_subnet.private[*].cidr_block
}

# 🔹 CIDR das subnets de banco de dados (para regras de segurança)
output "database_subnet_cidrs" {
  description = "Lista de CIDRs das subnets de banco de dados"
  value       = length(var.database_subnets) > 0 ? aws_subnet.database[*].cidr_block : []
}

# 🔹 CIDR das subnets de pods (para regras de segurança)
output "pods_subnet_cidrs" {
  description = "Lista de CIDRs das subnets de pods"
  value       = length(var.pods_subnets) > 0 ? aws_subnet.pods[*].cidr_block : []
}

# 🔹 IDs dos NAT Gateways criados
output "nat_gateway_ids" {
  description = "IDs dos NAT Gateways criados"
  value       = length(var.private_subnets) > 0 ? aws_nat_gateway.this[*].id : []
}

# 🔹 Tabela de Rotas Privadas
output "private_route_table_ids" {
  description = "IDs das tabelas de rotas das subnets privadas"
  value       = aws_route_table.private[*].id
}
