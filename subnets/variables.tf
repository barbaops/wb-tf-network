variable "vpc_id" {
  description = "ID da VPC onde a sub-rede será criada"
  type        = string
}

variable "subnet_name" {
  description = "Nome das sub-redes"
  type        = string
}

variable "subnet_cidrs" {
  description = "Lista de blocos CIDR para as sub-redes"
  type        = list(string)
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidade"
  type        = list(string)
}

variable "is_public" {
  description = "Se true, a sub-rede será pública"
  type        = bool
}

variable "tags" {
  description = "Tags aplicadas às sub-redes"
  type        = map(string)
  default     = {}
}
