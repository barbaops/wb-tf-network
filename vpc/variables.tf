variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
