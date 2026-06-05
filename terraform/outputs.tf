output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "vpc_id" {
  description = "Project Bedrock VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private subnet IDs used by EKS nodes"
  value       = module.vpc.private_subnets
}

output "database_subnet_ids" {
  description = "Private database subnet IDs"
  value       = module.vpc.database_subnets
}

output "cluster_endpoint" {
  description = "EKS Kubernetes API endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "catalog_db_endpoint" {
  description = "MySQL endpoint for the catalogue service"
  value       = aws_db_instance.catalog.address
}

output "orders_db_endpoint" {
  description = "PostgreSQL endpoint for the orders service"
  value       = aws_db_instance.orders.address
}

output "catalog_secret_arn" {
  description = "Secrets Manager ARN for catalogue database credentials"
  value       = aws_secretsmanager_secret.catalog.arn
}

output "orders_secret_arn" {
  description = "Secrets Manager ARN for orders database credentials"
  value       = aws_secretsmanager_secret.orders.arn
}

output "carts_table_name" {
  description = "DynamoDB table used by the carts service"
  value       = aws_dynamodb_table.carts.name
}

output "assets_bucket_name" {
  description = "S3 bucket used for uploaded product assets"
  value       = aws_s3_bucket.assets.bucket
}
