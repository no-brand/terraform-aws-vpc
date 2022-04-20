output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.private_subnets
}

output "intra_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.intra_subnets
}

output "database_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.database_subnets
}

output "vpc_endpoints" {
  description = "List of vpc endpoints"
  value       = module.vpc.vpc_endpoints
}
