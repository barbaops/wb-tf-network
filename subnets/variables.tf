variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "subnets" {
  description = "Lista de subnets a serem criadas"
  type = list(object({
    name = string
    cidr = string
    az   = string
    type = string
  }))
}

variable "tags" {
  description = "Tags padrões"
  type        = map(string)
  default     = {}
}
