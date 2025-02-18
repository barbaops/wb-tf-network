output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR principal da VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_additional_cidr" {
  description = "CIDR adicional (se configurado)"
  value       = length(aws_vpc_ipv4_cidr_block_association.additional) > 0 ? aws_vpc_ipv4_cidr_block_association.additional[0].cidr_block : null
}
