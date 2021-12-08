resource "aws_vpc" "this" {
  cidr_block = var.cidr

  tags       = merge({
    "Name" = format("%s-vpc", local.prefix_hyphen)
  }, var.tags)
}