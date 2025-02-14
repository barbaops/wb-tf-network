output "subnet_ids" {
  description = "IDs das sub-redes criadas"
  value       = aws_subnet.this[*].id
}
