# Project Bedrock

InnovateMart’s inaugural production-style deployment of the AWS Retail Store Sample Application on Amazon EKS.

## Required Standards

- AWS Region: `us-east-1`
- EKS Cluster: `project-bedrock-cluster`
- VPC Name: `project-bedrock-vpc`
- Kubernetes Namespace: `retail-app`
- Developer IAM User: `bedrock-dev-view`
- Lambda Function: `bedrock-asset-processor`
- Required Tag: `Project = karatu-2025-capstone`

## Repository Structure

- `bootstrap/` — Terraform remote-state infrastructure
- `terraform/` — Main AWS infrastructure
- `kubernetes/` — Kubernetes resources
- `helm/` — Application Helm configuration
- `lambda/` — Asset-processing Lambda function
- `.github/workflows/` — CI/CD pipelines
- `docs/` — Architecture and verification evidence
