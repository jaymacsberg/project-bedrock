module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  database_subnets = [
    "10.0.21.0/24",
    "10.0.22.0/24"
  ]

  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_nat_gateway = true
  single_nat_gateway = true

  create_database_subnet_group = true

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = local.common_tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.34"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  cloudwatch_log_group_retention_in_days = 3

  addons = {
    coredns = {}

    eks-pod-identity-agent = {
      before_compute = true
    }

    kube-proxy = {}

    vpc-cni = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    bedrock_nodes = {
      name = "bedrock-nodes"

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m7i-flex.large"]
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      desired_size = 2
      max_size     = 2

      disk_size = 30

      labels = {
        role = "general"
      }
    }
  }

  tags = local.common_tags
}
