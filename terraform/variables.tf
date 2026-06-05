variable "aws_region" {
  description = "AWS region for Project Bedrock"
  type        = string
  default     = "us-east-1"
}

variable "project_tag" {
  description = "Required project tag"
  type        = string
  default     = "karatu-2025-capstone"
}

variable "cluster_name" {
  description = "Required EKS cluster name"
  type        = string
  default     = "project-bedrock-cluster"
}

variable "vpc_name" {
  description = "Required VPC name"
  type        = string
  default     = "project-bedrock-vpc"
}

variable "application_namespace" {
  description = "Required Kubernetes namespace"
  type        = string
  default     = "retail-app"
}

variable "student_id" {
  description = "Unique student identifier used for globally unique resources"
  type        = string
}
