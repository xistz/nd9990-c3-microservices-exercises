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
  user       = module.iam_users["udagram-kubectl"].this_iam_user_name
  policy_arn = aws_iam_policy.eks_admin_policy.arn
}

data "http" "albc_policy_json" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.0/docs/install/iam_policy.json"
}

resource "aws_iam_policy" "albc" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = data.http.albc_policy_json.body
}

module "albc_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role                   = true
  role_name                     = "aws-load-balancer-controller"
  role_policy_arns              = [aws_iam_policy.albc.arn]
  provider_url                  = module.eks.cluster_oidc_issuer_url
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}
