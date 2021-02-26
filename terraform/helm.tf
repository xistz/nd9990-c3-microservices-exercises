resource "helm_release" "ingress" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  values = [yamlencode(
    {
      clusterName = data.aws_eks_cluster.cluster.name
      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
        annotations = {
          "eks.amazonaws.com/role-arn" = module.albc_irsa.this_iam_role_arn
        }
      }
    }
  )]
}
