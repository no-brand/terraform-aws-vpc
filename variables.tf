variable "namespace" {
  description = "Namespace of all resources as identifier."
  type        = string

  validation {
    condition     = can(regex("[[:lower:]]", var.namespace))
    error_message = "Namespace should be lowercase."
  }
}

variable "stage" {
  description = "Stage, such as dev, stg, and prd."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stg", "prd"], var.stage)
    error_message = "Stage should be one of [dev, stg, prd]."
  }
}

variable "region" {
  description = "AWS region to deploy."
  type        = string

  validation {
    condition     = length(regexall("[a-z]+-[a-z]+-[1-3]", var.region)) > 0
    error_message = "AWS Region format is not valid."
  }
}

variable "az_ids" {
  description = <<EOT
  A list of letter identifier for availability zone.
  Availability zone consists of region code followed by a letter identifier. (ex. ap-northeast-2a)
  EOT
  type        = list(string)
  default     = ["a", "b", "c"]

  validation {
    condition     = alltrue([
    for az_id in var.az_ids : (length(az_id) == 1 && contains(["a", "b", "c", "d"], az_id))
    ])
    error_message = "Each letter identifier for availability zone should be one of [a, b, c, d]."
  }
}

locals {
  region_abbreviation_map = {
    "us-east-1"      = "usea1"
    "us-east-2"      = "usea2"
    "us-west-1"      = "uswe1"
    "us-west-2"      = "uswe2"
    "us-gov-west-1"  = "ugwe1"
    "ca-central-1"   = "cace1"
    "eu-west-1"      = "euwe1"
    "eu-west-2"      = "euwe2"
    "eu-central-1"   = "euce1"
    "ap-southeast-1" = "apse1"
    "ap-southeast-2" = "apse2"
    "ap-south-1"     = "apso1"
    "ap-northeast-1" = "apne1"
    "ap-northeast-2" = "apne2"
    "ap-northeast-3" = "apne3"
    "sa-east-1"      = "saea1"
    "cn-north-1"     = "cnno1"
  }

  region_abbreviation = local.region_abbreviation_map[var.region]
  prefix_hyphen       = format("%s-%s-%s", var.namespace, var.stage, local.region_abbreviation)
  prefix_underline    = format("%s_%s_%s", var.namespace, var.stage, local.region_abbreviation)

  azs = [for az_id in var.az_ids : "${var.region}${az_id}"]

  subnets = {
    public   = aws_subnet.public
    private  = aws_subnet.private
    intra    = aws_subnet.intra
    database = aws_subnet.database
  }

  route_tables = {
    public   = aws_route_table.public
    private  = aws_route_table.private
    intra    = aws_route_table.intra
    database = aws_route_table.database
  }
}

variable "cidr" {
  description = "CIDR block of the VPC"
  type        = string
  default     = "10.255.0.0/16"
}

variable "tags" {
  description = "Map of tags"
  type        = map(string)
  default     = {}
}

variable "public_subnets" {
  description = "A list of public subnets, which has an internet gateway."
  type        = map(string)
  default     = {
    a = "10.255.0.0/22"
    b = "10.255.4.0/22"
    c = "10.255.8.0/22"
  }
}

variable "private_subnets" {
  description = "A list of private subnets, which has a nat gateway."
  type        = map(string)
  default     = {
    a = "10.255.20.0/22"
    b = "10.255.24.0/22"
    c = "10.255.28.0/22"
  }
}

variable "intra_subnets" {
  description = "A list of intra subnets, which is isolated from public."
  type        = map(string)
  default     = {
    a = "10.255.40.0/22"
    b = "10.255.44.0/22"
    c = "10.255.48.0/22"
  }
}

variable "database_subnets" {
  description = "A list of database subnets, which is isolated from public."
  type        = map(string)
  default     = {
    a = "10.255.60.0/22"
    b = "10.255.64.0/22"
    c = "10.255.68.0/22"
  }
}

variable "vpc_endpoints" {
  description = <<EOF
A list of vpc endpoints, which helps to communicate AWS resource with internal networks.
list consists of map objects, key is service name of vpc endpoint, and value should have below information.
1. type: service type of vpc endpoint [Gateway, Interface]
2. subnet: associated subnets.
EOF
  default = {
    s3 = {
      type   = "Gateway"
      subnet = ["private", "intra"]
    }
  }
}
