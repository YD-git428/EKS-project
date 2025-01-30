output "cluster_role" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "worker_role" {
  value = aws_iam_role.eks_worker_role.arn
}

