variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR da VPC"
  type        = string
}

variable "additional_cidr_block" {
  description = "CIDR adicional para a VPC (opcional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags a serem aplicadas na VPC"
  type        = map(string)
}
