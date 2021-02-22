module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "udagram"
  cluster_version = "1.18"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  node_groups = {
    first = {
      desired_capacity = 1
      max_capacity     = 5
      min_capacity     = 1

      instance_type = "t3.micro"
    }
  }

  map_users = [
    {
      userarn  = module.iam_users["udagram-kubectl"].this_iam_user_arn
      username = module.iam_users["udagram-kubectl"].this_iam_user_name
      groups   = ["system:masters"]
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
