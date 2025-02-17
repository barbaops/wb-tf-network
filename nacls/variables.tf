variable "vpc_id" {
  description = "ID da VPC onde as NACLs serão criadas"
  type        = string
}

variable "nacls" {
  description = "Lista de NACLs a serem criadas e suas regras associadas"
  type = list(object({
    name       = string
    subnet_ids = list(string)

    rules = list(object({
      rule_number = number
      rule_action = string
      protocol    = string
      cidr_block  = string
      from_port   = number
      to_port     = number
      egress      = bool
    }))
  }))
}

variable "tags" {
  description = "Tags aplicadas aos recursos"
  type        = map(string)
  default     = {}
}
