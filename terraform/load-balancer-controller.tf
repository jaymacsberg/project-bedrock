data "aws_iam_policy_document" "load_balancer_controller_assume_role" {
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

resource "aws_iam_role" "load_balancer_controller" {
  name               = "project-bedrock-load-balancer-controller"
  assume_role_policy = data.aws_iam_policy_document.load_balancer_controller_assume_role.json
}

resource "aws_iam_policy" "load_balancer_controller" {
  name   = "project-bedrock-load-balancer-controller"
  policy = file("${path.module}/lbc_iam_policy.json")
}

resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  role       = aws_iam_role.load_balancer_controller.name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}

resource "aws_eks_pod_identity_association" "load_balancer_controller" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.load_balancer_controller.arn
}
