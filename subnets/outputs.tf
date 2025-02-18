output "vpc_id" {
  description = "ID da VPC criada"
  value       = var.vpc_id
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway criado (se existir)"
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway (se criado)"
  value       = length(aws_nat_gateway.this) > 0 ? aws_nat_gateway.this[0].id : null
}

output "public_route_table_id" {
  description = "ID da Route Table pública"
  value       = length(aws_route_table.this) > 0 ? aws_route_table.this[0].id : null
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas criadas"
  value       = { for subnet in aws_subnet.this : subnet.tags.Name => subnet.id if subnet.map_public_ip_on_launch }
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas criadas"
  value       = { for subnet in aws_subnet.this : subnet.tags.Name => subnet.id if !subnet.map_public_ip_on_launch }
}

output "database_subnet_ids" {
  description = "IDs das subnets de banco de dados criadas"
  value       = { for subnet in aws_subnet.this : subnet.tags.Name => subnet.id if subnet.tags.Type == "database" }
}

output "pods_subnet_ids" {
  description = "IDs das subnets para Pods (EKS) criadas"
  value       = { for subnet in aws_subnet.this : subnet.tags.Name => subnet.id if subnet.tags.Type == "pods" }
}

output "subnet_cidrs" {
  description = "Lista de CIDRs de todas as subnets criadas"
  value       = { for subnet in aws_subnet.this : subnet.tags.Name => subnet.cidr_block }
}
