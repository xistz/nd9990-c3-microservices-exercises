module "s3_images" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name
  acl    = "private"

  cors_rule = {
    allowed_origins = ["*"]
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "DELETE"]
  }

  force_destroy = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "udagram_bucket" {
  name = "udagram-bucket"

  tags = {
    Name = "Udagram bucket"
  }
}

data "aws_iam_policy_document" "udagram_bucket" {
  version = "2012-10-17"
  statement {
    sid    = "S3AccessPolicy"
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.udagram.arn}/*"
    ]
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
  }
}

resource "aws_iam_user_policy" "udagram_bucket" {
  name   = "udagram-bucket"
  user   = aws_iam_user.udagram_bucket.name
  policy = data.aws_iam_policy_document.udagram_bucket.json
}

resource "aws_iam_access_key" "udagram_bucket" {
  user = aws_iam_user.udagram_bucket.name
}
