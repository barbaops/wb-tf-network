resource "aws_vpc_endpoint" "this" {
  vpc_id       = var.vpc_id
  service_name = var.service_name
  vpc_endpoint_type = var.endpoint_type

  tags = var.tags
}
