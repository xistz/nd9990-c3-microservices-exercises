module "iam_users" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  for_each = toset(["udagram-bucket", "udagram-kubectl"])

  create_iam_user_login_profile = false
  name                          = each.value
  force_destroy                 = true
}
