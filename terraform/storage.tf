module "s3_images" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  cors_rule = [
    {
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      allowed_methods = ["PUT", "POST", "DELETE"]
    }
  ]

  attach_policy = true
  policy        = data.aws_iam_policy_document.udagram_bucket.json

  force_destroy = true
}

data "aws_iam_policy_document" "udagram_bucket" {
  version = "2012-10-17"
  statement {
    sid    = "S3AccessPolicy"
    effect = "Allow"
    resources = [
      module.s3_images.this_s3_bucket_arn,
      "${module.s3_images.this_s3_bucket_arn}/*"
    ]
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    principals {
      type        = "AWS"
      identifiers = [module.iam_users["udagram-bucket"].this_iam_user_arn]
    }
  }
}
