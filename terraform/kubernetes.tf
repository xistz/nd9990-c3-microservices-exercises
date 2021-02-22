resource "random_password" "jwt_secret" {
  length = 16
}

resource "kubernetes_secret" "udagram" {
  metadata {
    name = "udagram-secrets"
  }

  data = {
    db_host                      = module.db.this_db_instance_address
    db_user                      = module.db.this_db_instance_username
    db_password                  = module.db.this_db_instance_password
    aws_bucket                   = module.s3_images.this_s3_bucket_id
    aws_bucket_access_key_id     = module.iam_users["udagram-bucket"].this_iam_access_key_id
    aws_bucket_secret_access_key = module.iam_users["udagram-bucket"].this_iam_access_key_secret
    jwt_secret                   = random_password.jwt_secret.result
  }
}

resource "kubernetes_config_map" "udagram" {
  metadata {
    name = "udagram-configmap"
  }

  data = {
    db_name    = module.db.this_db_instance_name
    aws_region = var.region
  }
}
