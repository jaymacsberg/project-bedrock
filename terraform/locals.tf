locals {
  common_tags = {
    Project = var.project_tag
  }

  assets_bucket_name = "bedrock-assets-${var.student_id}"
}
