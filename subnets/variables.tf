variable "vpc_id" {
  description = "ID da VPC onde as sub-redes serão criadas"
  type        = string
}

#variable "vpc_name" {
#  description = "Nome da VPC para referência nas subnets"
#  type        = string
#}

variable "subnets" {
  description = "Lista de sub-redes a serem criadas, com detalhes de configuração"
  type = list(object({
    name  = string  # Nome da subnet (ex: database, app, cache)
    cidr  = string  # CIDR da subnet
    az    = string  # Zona de Disponibilidade
    type  = string  # Tipo da subnet (public, private, database, etc.)
    public = optional(bool, false)  # Define se a subnet é pública ou privada (padrão: privada)
  }))
}

variable "tags" {
  description = "Tags adicionais para todas as subnets"
  type        = map(string)
  default     = {}
}
