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
    url        = "http://localhost:8080"
  }
}

resource "kubernetes_ingress" "udagram" {
  wait_for_load_balancer = true
  metadata {
    name = "udagram-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = "udagram-reverse-proxy"
            service_port = 8080
          }

          path = "/*"
        }
      }
    }
  }

  depends_on = [
    helm_release.ingress
  ]
}

resource "kubernetes_horizontal_pod_autoscaler" "udagram" {
  for_each = toset(["udagram-feed-api", "udagram-user-api"])
  metadata {
    name = "${each.value}-hpa"
  }

  spec {
    min_replicas                      = 1
    max_replicas                      = 10
    target_cpu_utilization_percentage = 50

    scale_target_ref {
      kind = "Deployment"
      name = each.value
    }
  }
}
