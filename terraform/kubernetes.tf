resource "aws_iam_role" "udagram_cluster" {
  name = "udagram-eks-cluster-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "udagram_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.udagram_cluster.name
}

resource "aws_iam_role_policy_attachment" "udagram_eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.udagram_cluster.name
}


resource "aws_eks_cluster" "udagram" {
  name     = "udagram"
  role_arn = aws_iam_role.udagram_cluster.arn

  vpc_config {
    subnet_ids = aws_subnet.udagram_public[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.udagram_eks_cluster_policy,
    aws_iam_role_policy_attachment.udagram_eks_service_policy
  ]
}
