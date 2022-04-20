locals {
  region = "us-west-1"
}

provider "aws" {
  region = local.region
}

module "vpc" {
  source    = "no-brand/vpc/aws"

  namespace = "example"
  region    = local.region
  stage     = "dev"
  cidr      = "10.192.0.0/16"

  public_subnets = {
    a = "10.192.0.0/22"
    b = "10.192.4.0/22"
    c = "10.192.8.0/22"
  }

  private_subnets = {
    a = "10.192.20.0/22"
    b = "10.192.24.0/22"
    c = "10.192.28.0/22"
  }

  intra_subnets = {
    a = "10.192.40.0/22"
    b = "10.192.44.0/22"
    c = "10.192.48.0/22"
  }

  database_subnets = {
    a = "10.192.60.0/22"
    b = "10.192.64.0/22"
    c = "10.192.68.0/22"
  }

  vpc_endpoints = {
    s3 = {
      type   = "Gateway"
      subnet = ["private", "intra"]
    }
  }

  tags = {
    Stage = "dev"
    Owner = "no-brand"
  }
}
