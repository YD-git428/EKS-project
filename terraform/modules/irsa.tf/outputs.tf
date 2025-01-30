output "external_dns_role" {
  value = module.external_dns_irsa_role.iam_role_arn
}

output "cert_manager_role" {
  value = module.cert_manager_irsa_role.iam_role_arn
}