output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.this.id
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "vpc_name" {
  description = "Nome da VPC"
  value       = aws_vpc.this.tags["Name"]
}
