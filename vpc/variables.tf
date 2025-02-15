variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "tags" {
  description = "Tags a serem aplicadas à VPC"
  type        = map(string)
  default     = {}
}
