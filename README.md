# Project Bedrock — AWS EKS Cloud Infrastructure Capstone

Project Bedrock is a cloud infrastructure capstone focused on deploying and validating a Kubernetes-based retail application environment on AWS.

The project demonstrates hands-on work with AWS, Amazon EKS, Terraform, Kubernetes, Helm, IAM, VPC networking, S3, Lambda, GitHub Actions, infrastructure validation, documentation, and troubleshooting.

This repository is presented as a capstone and learning project, not as a live production system.

---

## Project Objectives

* Provision AWS infrastructure using Terraform
* Configure remote Terraform state infrastructure
* Deploy and configure Kubernetes resources on Amazon EKS
* Use Helm charts and environment values for application deployment
* Configure namespace and ALB ingress resources
* Integrate S3 and Lambda for asset-processing functionality
* Use GitHub Actions for Terraform CI/CD workflows
* Generate required grading outputs
* Document architecture, deployment steps, validation evidence, and troubleshooting notes

---

## Technologies Used

* AWS
* Amazon EKS
* Terraform
* Kubernetes
* Helm
* IAM
* VPC networking
* S3
* AWS Lambda
* GitHub Actions
* Bash

---

## Repository Structure

| Path                 | Purpose                                        |
| -------------------- | ---------------------------------------------- |
| `bootstrap/`         | Remote Terraform state infrastructure          |
| `terraform/`         | AWS infrastructure configuration               |
| `helm/`              | Retail Store Helm charts and production values |
| `kubernetes/`        | Namespace and ALB Ingress manifests            |
| `lambda/`            | Asset-processing Lambda code                   |
| `.github/workflows/` | Terraform CI/CD workflows                      |
| `docs/`              | Architecture and verification evidence         |
| `grading.json`       | Required Terraform grading outputs             |
| `Deployment Guide`   | Deployment instructions and validation steps   |

---

## Infrastructure Scope

The project includes configuration and deployment work for:

* Terraform remote state
* AWS infrastructure provisioning
* Amazon EKS cluster configuration
* Kubernetes namespace and ingress resources
* Helm-based Retail Store deployment configuration
* IAM and access-control requirements
* S3 asset storage integration
* Lambda-based asset processing
* Terraform CI/CD workflow validation
* Deployment evidence and troubleshooting documentation

---

## Deployment Overview

A typical deployment flow includes:

1. Bootstrap Terraform remote-state infrastructure
2. Provision AWS infrastructure using Terraform
3. Configure Kubernetes access for the EKS environment
4. Deploy namespace and ingress manifests
5. Deploy Retail Store resources using Helm
6. Configure and validate S3/Lambda asset-processing components
7. Run validation checks for infrastructure and application resources
8. Generate and commit the required `grading.json` output
9. Document architecture decisions, verification evidence, and troubleshooting notes

Detailed deployment instructions are maintained in the Deployment Guide.

---

## Validation and Troubleshooting

Validation work for this capstone included:

* Terraform formatting and validation checks
* Terraform plan review
* EKS and Kubernetes resource verification
* Namespace and ingress validation
* Helm deployment checks
* S3 and Lambda integration checks
* Review of required grading resources and outputs
* Documentation of deployment evidence and troubleshooting steps

---

## Security and Repository Hygiene

This repository should not contain credentials, private keys, kubeconfig files, Terraform state files, `.env` files, or secret variable files.

Sensitive runtime values should be managed outside the repository using AWS IAM, local environment variables, GitHub repository secrets, or secure Terraform variable handling.

---

## Status

Capstone / learning project.

The infrastructure may not currently be running, and any previously generated public endpoints may no longer be active.

---

## Career Relevance

This project demonstrates practical cloud infrastructure skills relevant to junior cloud, infrastructure support, DevOps, and platform support roles, including:

* Infrastructure as Code with Terraform
* Kubernetes deployment on AWS EKS
* Helm-based application deployment
* Cloud networking and IAM configuration
* S3/Lambda integration
* CI/CD-oriented Terraform workflows
* Deployment validation and troubleshooting
* Technical documentation and operational evidence
