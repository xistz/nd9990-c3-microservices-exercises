module "iam_users" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  for_each = toset(["udagram-bucket", "udagram-kubectl"])

  create_iam_user_login_profile = false
  name                          = each.value
  force_destroy                 = true
}

data "aws_iam_policy_document" "eks_admin_policy" {
  statement {
    actions = [
      "eks:*"
    ]

    resources = [
      module.eks.cluster_arn
    ]
  }

  statement {
    actions = [
      "iam:PassRole",
    ]

    resources = [
      module.eks.cluster_arn
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"

      values = [
        "eks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_policy" "eks_admin_policy" {
  name   = "AmazonEKSAdminPolicy"
  policy = data.aws_iam_policy_document.eks_admin_policy.json
}

resource "aws_iam_user_policy_attachment" "udagram_kubectl" {
  user       = module.iam_users["udagram_kubectl"].this_iam_user_name
  policy_arn = aws_iam_policy.eks_admin_policy.arn
}
