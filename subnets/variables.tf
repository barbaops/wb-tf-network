variable "vpc_id" {
  description = "ID da VPC onde as subnets serão criadas"
  type        = string
}

variable "subnets" {
  description = "Lista de subnets a serem criadas"
  type = list(object({
    name   = string
    cidr   = string
    az     = string
    type   = string
    public = optional(bool, false)
  }))
}

variable "create_nat_gateway" {
  description = "Se verdadeiro, cria um NAT Gateway"
  type        = bool
  default     = false
}

variable "nat_subnet" {
  description = "Nome da subnet pública onde o NAT Gateway será criado"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags aplicadas aos recursos"
  type        = map(string)
  default     = {}
}
