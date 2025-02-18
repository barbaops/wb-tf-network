variable "vpc_id" {
  description = "ID da VPC onde as NACLs serão criadas"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "nacls" {
  description = "Lista de NACLs a serem criadas"
  type = list(object({
    name       = string
    subnet_ids = list(string)

    ingress_rules = list(object({
      rule_number = number
      protocol    = string
      action      = string
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))

    egress_rules = list(object({
      rule_number = number
      protocol    = string
      action      = string
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))
  }))
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
}
