terraform {
  backend "s3" {
    bucket       = "project-bedrock-tfstate-627073649740"
    key          = "project-bedrock/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
