variable "region" {
  description = "Região da AWS onde a VPC será criada"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
}

variable "dns_support" {
  description = "DNS Support"
  type        = bool
}

variable "dns_hostnames" {
  description = "Enable DNS Hostnames resolve"
  type        = bool
}

variable "tags" {
  description = "Tags para a VPC"
  type        = map(string)
  default     = {}
}
