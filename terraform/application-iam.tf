data "aws_iam_policy_document" "carts_pod_identity_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "carts_pod_identity" {
  name               = "project-bedrock-carts-pod-role"
  assume_role_policy = data.aws_iam_policy_document.carts_pod_identity_assume_role.json
}

resource "aws_iam_role_policy" "carts_dynamodb_access" {
  name = "project-bedrock-carts-dynamodb-access"
  role = aws_iam_role.carts_pod_identity.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ]

      Resource = [
        aws_dynamodb_table.carts.arn,
        "${aws_dynamodb_table.carts.arn}/index/*"
      ]
    }]
  })
}

resource "aws_eks_pod_identity_association" "carts" {
  cluster_name    = module.eks.cluster_name
  namespace       = "retail-app"
  service_account = "carts"
  role_arn        = aws_iam_role.carts_pod_identity.arn
}
