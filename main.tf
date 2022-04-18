# {namespace}-{stage}-{region}-vpc
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    "Name" = format("%s-vpc", local.prefix_hyphen)
  }, var.tags)
}

# {namespace}-{stage}-{region}-igw
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    "Name" = format("%s-igw", local.prefix_hyphen)
  }, var.tags)
}

# {namespace}-{stage}-{region}-public-subnet
resource "aws_subnet" "public" {
  for_each = {for az_id, subnet in var.public_subnets: "${var.region}${az_id}" => subnet}

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true

  tags = merge({
    "Name" = format("%s-public-subnet", local.prefix_hyphen)
  }, var.tags)
}

# {namespace}-{stage}-{region}-public-subnet-rtb
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    "Name" = format("%s-public-subnet-rtb", local.prefix_hyphen)
  }, var.tags)
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = {for az_id, subnet in var.public_subnets: "${var.region}${az_id}" => subnet}

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}
