output "subnet_ids" {
  description = "IDs das subnets criadas"
  value       = { for k, v in aws_subnet.this : k => v.id }
}

output "route_table_ids" {
  description = "IDs das Route Tables"
  value = {
    public  = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : null
    private = { for k, v in aws_route_table.private : k => v.id }
    database = length(aws_route_table.database) > 0 ? aws_route_table.database[0].id : null
    pods = length(aws_route_table.pods) > 0 ? aws_route_table.pods[0].id : null
  }
}

output "nat_gateway_ids" {
  description = "IDs dos NAT Gateways"
  value       = { for k, v in aws_nat_gateway.this : k => v.id }
}
