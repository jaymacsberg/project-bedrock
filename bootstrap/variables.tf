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
