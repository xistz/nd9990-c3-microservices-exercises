locals {
  k8s_secrets = <<-K8SSECRETS
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: udagram-secrets
  type: Opaque
  stringData:
    db_host: ${module.db.this_db_instance_address}
    db_user: ${module.db.this_db_instance_username}
    db_password: ${module.db.this_db_instance_password}
    aws_bucket: ${module.s3_images.this_s3_bucket_id}
    aws_bucket_access_key_id: ${module.iam_users["udagram-bucket"].this_iam_access_key_id}
    aws_bucket_secret_access_key: ${module.iam_users["udagram-bucket"].this_iam_access_key_secret}
    jwt_secret: ${random_password.jwt_secret.result}
  K8SSECRETS
  env_dev     = <<-ENVDEV
  POSTGRES_USERNAME=${module.db.this_db_instance_username}
  POSTGRES_PASSWORD=${module.db.this_db_instance_password}
  POSTGRES_DB=${module.db.this_db_instance_name}
  POSTGRES_HOST=${module.db.this_db_instance_address}
  AWS_REGION=${var.region}
  AWS_BUCKET=${module.s3_images.this_s3_bucket_id}
  AWS_BUCKET_ACCESS_KEY_ID=${module.iam_users["udagram-bucket"].this_iam_access_key_id}
  AWS_BUCKET_SECRET_ACCESS_KEY=${module.iam_users["udagram-bucket"].this_iam_access_key_secret}
  JWT_SECRET=${random_password.jwt_secret.result}
  ENVDEV
}

resource "local_file" "k8s_secrets" {
  count = var.debug ? 1 : 0

  sensitive_content = local.k8s_secrets
  filename          = "${path.module}/../k8s/udagram-secrets.yaml"
}

resource "local_file" "env_dev" {
  count = var.debug ? 1 : 0

  sensitive_content = local.env_dev
  filename          = "${path.module}/../project/.env.dev"
}
