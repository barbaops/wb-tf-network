output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_name" {
  description = "Nome da VPC"
  value       = aws_vpc.this.tags["Name"]
}
