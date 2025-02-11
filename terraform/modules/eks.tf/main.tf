module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.0"

  cluster_name    = var.cluster-name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_cidrs
  cluster_endpoint_public_access       = true

  cluster_addons = {
    vpc-cni = {}
  }

  iam_role_arn = var.iamrole_cluster

  create_cloudwatch_log_group = true

  enable_irsa = true

  vpc_id = var.vpcid_

  subnet_ids = var.subnetids_public

  create_node_security_group = true


  create_iam_role = false

  create_node_iam_role = false

  access_entries = var.access_entry



  eks_managed_node_group_defaults = {
    ami_type               = var.ami_type
    instance_types         = var.instance_types
    iam_role_arn           = var.iam_role_workernode
    create_iam_role        = false
    create_iam_role_policy = true
    cluster_name           = var.cluster-name
    subnet_ids             = var.subnetids_private
  }

  eks_managed_node_groups = var.managed_node_groups
}
















