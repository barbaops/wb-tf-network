variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "nacl_name" {
  description = "Nome da NACL"
  type        = string
}

variable "ingress_rules" {
  description = "Regras de entrada para NACL"
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
  }))
}

variable "tags" {
  description = "Tags a serem aplicadas"
  type        = map(string)
  default     = {}
}
