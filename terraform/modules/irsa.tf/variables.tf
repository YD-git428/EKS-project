variable "oidc_provider_arn" {
  type = string
}

variable "cert_manager_role_name" {
  type = string
}

variable "external_dns_role_name" {
  type = string
}

variable "hosted_zone_arns" {
  type = list(string)
}

variable "cert_manager_role_tag" {
  type = string
}

variable "external_dns_role_tag" {
  type = string
}

variable "cert_namespace_service_accounts" {
  type = list(string)
}

variable "external_dns_namespace_service_accounts" {
  type = list(string)
}