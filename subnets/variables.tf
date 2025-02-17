variable "vpc_id" {
  description = "ID da VPC onde as subnets serão criadas"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "public_subnets" {
  description = "Lista de subnets públicas (opcional)"
  type = list(object({
    name = string
    cidr = string
    az   = string
  }))
  default = []
}

variable "private_subnets" {
  description = "Lista de subnets privadas (opcional)"
  type = list(object({
    name = string
    cidr = string
    az   = string
  }))
  default = []
}

variable "database_subnets" {
  description = "Lista de subnets para banco de dados (opcional)"
  type = list(object({
    name = string
    cidr = string
    az   = string
  }))
  default = []
}

variable "pods_subnets" {
  description = "Lista de subnets para PODs do EKS (opcional)"
  type = list(object({
    name = string
    cidr = string
    az   = string
  }))
  default = []
}

variable "tags" {
  description = "Tags aplicadas aos recursos"
  type        = map(string)
  default     = {}
}
