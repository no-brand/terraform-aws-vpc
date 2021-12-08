# Terraform Module: AWS VPC

## How to use
Define a module with the source, `no-brand/vpc/aws`. <br>
Then, pass variables to fit your needs. <br>
```hcl-terraform
module "vpc" {
  source    = "no-brand/vpc/aws"
  
  namespace = "nb"
  region    = "ap-northeast-3"
  stage     = "dev"
  cidr      = "10.255.0.0/16"

  tags      = {
    Stage = "dev"
    Owner = "no-brand"
  }
}
```

## Examples

## How to contribute

## Requirements

## Providers

## License
Apache License 2.0
