module "cert_manager_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "eks-cert-manager-role"

  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z02736193B0NBZU8BTQQK"]

  oidc_providers = {                                           
    eks = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["eks-cert-manager:cert-manager"]
    }
  }

  tags = {
    name = "eks-cert-manager"
  }
}

module "external_dns_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "eks-external-dns-role"

  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z02736193B0NBZU8BTQQK"]

  oidc_providers = {
    eks = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["eks-external-dns:external-dns"]
    }
  }

  

  tags = {
    name = "eks-external-dns"
  }
}