resource "random_password" "secret" {
  length = 16
}

locals {
  k8s_secrets = <<-K8SSECRETS
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: udagram-secrets
  type: Opaque
  stringData:
    db_host: ${aws_db_instance.udagram.address}
    db_user: ${aws_db_instance.udagram.username}
    db_password: ${aws_db_instance.udagram.password}
    aws_bucket: ${aws_s3_bucket.udagram.bucket}
    aws_bucket_access_key_id: ${aws_iam_access_key.udagram_bucket.id}
    aws_bucket_secret_access_key: ${aws_iam_access_key.udagram_bucket.secret}
    jwt_secret: ${random_password.secret.result}
  K8SSECRETS
}

resource "local_file" "k8s_secrets" {
  content  = local.k8s_secrets
  filename = "${path.module}/../project/k8s/udagram-secrets.yaml"
}
