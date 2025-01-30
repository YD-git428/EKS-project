output "eks_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "eks_cert_authority" {
  value = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "access_entry" {
  value = module.eks.access_entries
}