# Project Bedrock Architecture

```mermaid
flowchart TB
    Internet[Internet Users]

    subgraph AWS["AWS Region: us-east-1"]
        ALB[Application Load Balancer]

        subgraph VPC["VPC: project-bedrock-vpc"]
            subgraph Public["Public Subnets - 2 AZs"]
                ALB
                NAT[NAT Gateway]
            end

            subgraph Private["Private Subnets - 2 AZs"]
                subgraph EKS["EKS: project-bedrock-cluster"]
                    UI[UI Service]
                    Catalog[Catalog Service]
                    Carts[Carts Service]
                    Orders[Orders Service]
                    Checkout[Checkout Service]
                    CWAgent[CloudWatch Observability Add-on]
                end
            end

            subgraph DBSubnets["Private Database Subnets"]
                MySQL[(RDS MySQL)]
                Postgres[(RDS PostgreSQL)]
            end
        end

        Dynamo[(DynamoDB: project-bedrock-carts)]
        Secrets[Secrets Manager]
        CloudWatch[CloudWatch Logs]

        S3[(S3: bedrock-assets-alt-soe-025-3646)]
        Lambda[Lambda: bedrock-asset-processor]
    end

    Internet --> ALB
    ALB --> UI

    UI --> Catalog
    UI --> Carts
    UI --> Orders
    UI --> Checkout

    Catalog --> MySQL
    Orders --> Postgres
    Carts --> Dynamo

    Secrets --> Catalog
    Secrets --> Orders

    CWAgent --> CloudWatch
    EKS --> CloudWatch

    S3 -->|ObjectCreated event| Lambda
    Lambda -->|Image received log| CloudWatch
