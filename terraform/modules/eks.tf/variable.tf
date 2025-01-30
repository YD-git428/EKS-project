variable "cluster-name" {
  type = string
}

variable "vpcid_" {
  type = string
}

variable "subnetids_private" {
  type = list(string)
}

variable "subnetids_public" {
  type = list(string)
}

variable "iamrole_cluster" {
  type = string
}

variable "iam_role_workernode" {
  type = string
}

variable "access_entry" {
  type = map(object({
    cluster_name  = string
    principal_arn = string
    type          = string
    policy_associations = map(object({
      policy_arn = string
      access_scope = object({
        type = string
      })
    }))
  }))
}


