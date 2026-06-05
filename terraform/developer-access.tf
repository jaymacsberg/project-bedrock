resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"

  tags = {
    Name = "bedrock-dev-view"
  }
}

resource "aws_iam_user_policy_attachment" "bedrock_dev_readonly" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy" "bedrock_dev_assets_upload" {
  name = "bedrock-assets-upload"
  user = aws_iam_user.bedrock_dev_view.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "s3:PutObject"
      ]

      Resource = "arn:aws:s3:::${local.assets_bucket_name}/*"
    }]
  })
}

resource "aws_iam_access_key" "bedrock_dev_view" {
  user = aws_iam_user.bedrock_dev_view.name
}

resource "aws_eks_access_entry" "bedrock_dev_view" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_user.bedrock_dev_view.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "bedrock_dev_view" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_user.bedrock_dev_view.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  access_scope {
    type       = "namespace"
    namespaces = ["retail-app"]
  }

  depends_on = [aws_eks_access_entry.bedrock_dev_view]
}
