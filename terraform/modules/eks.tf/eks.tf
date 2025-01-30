module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.0"

  cluster_name = var.cluster-name
  cluster_version = "1.32"


  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = ["188.30.140.0/24"]
  cluster_endpoint_public_access       = true

  cluster_addons = {
    vpc-cni                = {}
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
    ami_type               = "AL2023_x86_64_STANDARD"
    instance_types         = ["t3.medium"]
    iam_role_arn           = var.iam_role_workernode
    create_iam_role        = false
    create_iam_role_policy = true
    cluster_name           = var.cluster-name
  }

  eks_managed_node_groups = {
    default = {
      min_size     = 2
      max_size     = 6
      desired_size = 3
    }
  }

}
















