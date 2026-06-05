cd ~/projects/project-bedrock

cat > README.md <<'EOF'
# Project Bedrock

Production-style deployment of the AWS Retail Store Sample Application on Amazon EKS.

## Required Standards

- AWS Region: `us-east-1`
- EKS Cluster: `project-bedrock-cluster`
- VPC Name: `project-bedrock-vpc`
- Kubernetes Namespace: `retail-app`
- Developer IAM User: `bedrock-dev-view`
- Assets Bucket: `bedrock-assets-alt-soe-025-3646`
- Lambda Function: `bedrock-asset-processor`
- Required Tag: `Project = karatu-2025-capstone`

## Architecture

See [docs/architecture.md](docs/architecture.md).

## Application URL

http://k8s-retailap-retailui-97ec739f01-873216349.us-east-1.elb.amazonaws.com

## Repository Structure

- `bootstrap/` — Remote Terraform state infrastructure
- `terraform/` — AWS infrastructure
- `helm/` — Retail Store Helm charts and production values
- `kubernetes/` — Namespace and ALB Ingress manifests
- `lambda/` — Asset-processing Lambda code
- `.github/workflows/` — Terraform CI/CD workflows
- `docs/` — Architecture and verification evidence
- `grading.json` — Required Terraform grading outputs

## Deployment Guide

### 1. Bootstrap Remote State

```bash
cd bootstrap
terraform init
terraform apply


2. Deploy AWS Infrastructure
cd ../terraform
terraform init
terraform plan
terraform apply

3. Configure EKS Access
aws eks update-kubeconfig \
  --region us-east-1 \
  --name project-bedrock-cluster

4. Deploy the Retail Store Application
kubectl apply -f kubernetes/namespace.yaml

helm upgrade --install catalog helm/retail-store/catalog \
  --namespace retail-app \
  --values helm/retail-store/catalog/values-production.yaml

helm upgrade --install carts helm/retail-store/carts \
  --namespace retail-app \
  --values helm/retail-store/carts/values-production.yaml

helm upgrade --install orders helm/retail-store/orders \
  --namespace retail-app \
  --values helm/retail-store/orders/values-production.yaml

helm upgrade --install checkout helm/retail-store/checkout \
  --namespace retail-app \
  --values helm/retail-store/checkout/values-production.yaml

helm upgrade --install ui helm/retail-store/ui \
  --namespace retail-app \
  --values helm/retail-store/ui/values-production.yaml

kubectl apply -f kubernetes/ingress.yaml
CI/CD Pipeline
Pull Request

A pull request targeting main triggers:

Terraform format check
Terraform initialisation
Terraform validation
Terraform plan
Plan output posted as a pull-request comment
Merge to Main

Merging into main triggers:

Terraform initialisation
Terraform validation
Terraform apply

AWS credentials are stored as GitHub repository secrets.

Verification
kubectl get pods -n retail-app
kubectl get ingress -n retail-app

Developer read-only verification:

KUBECONFIG=/tmp/bedrock-dev-kubeconfig kubectl get pods -n retail-app

Developer deletion must fail:

KUBECONFIG=/tmp/bedrock-dev-kubeconfig kubectl delete pod POD_NAME \
  -n retail-app \
  --dry-run=server
Serverless Test
aws s3 cp test-product-image.jpg \
  s3://bedrock-assets-alt-soe-025-3646/test-product-image.jpg \
  --profile bedrock-dev-view

Verify CloudWatch logs contain:

Image received: test-product-image.jpg
Important

Credentials, Terraform state files, kubeconfig files and secret variable files are not committed to this repository.
EOF
