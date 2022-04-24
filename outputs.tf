output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "azs" {
  value = local.azs
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = [for az, subnet in aws_subnet.public : subnet["id"]]
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = [for az, subnet in aws_subnet.private : subnet["id"]]
}

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = [for az, subnet in aws_subnet.intra : subnet["id"]]
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = [for az, subnet in aws_subnet.database : subnet["id"]]
}

output "vpc_endpoints" {
  description = "List of vpc endpoints"
  value = { for service, doc in aws_vpc_endpoint.this : service => {
    type           = doc["vpc_endpoint_type"]
    id             = doc["id"]
    prefix_list_id = doc["prefix_list_id"]
  } }
}
