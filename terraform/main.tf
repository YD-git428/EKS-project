module "vpc" {
  source = "./modules/vpc"

  vpc_tag             = "eks-vpc"
  route_tablepriv_tag = "private-rtable"
  route_tablepub_tag  = "public-rtable"
  subnet1_tag         = "public-subnet1"
  subnet2_tag         = "public-subnet2"
  subnet3_tag         = "public-subnet3"
  subnet1pub_tag      = "private-subnet1"
  subnet2pub_tag      = "private-subnet2"
  subnet3pub_tag      = "private-subnet3"
  availability_zone1  = "eu-west-2a"
  availability_zone2  = "eu-west-2b"
  availability_zone3  = "eu-west-2c"
  igw_tag             = "eks-igw"
  security_group_tag  = "workernode-sg"
  eks_eip1_name       = "eks-eip1"
  eks_eip2_name       = "eks-eip2"
  eks_eip3_name       = "eks-eip3"
  eks_nat_tag1        = "eks-nat1"
  eks_nat_tag2        = "eks-nat2"
  eks_nat_tag3        = "eks-nat3"
}

module "eks_module" {
  source       = "./modules/eks.tf"
  cluster-name = "YoucefEKS-project"
  vpcid_       = module.vpc.vpcid
  subnetids_public = [module.vpc.subnet1_id,
    module.vpc.subnet2_id,
  module.vpc.subnet3_id]
  subnetids_private = [module.vpc.subnet4_id,
    module.vpc.subnet5_id,
  module.vpc.subnet6_id]
  iamrole_cluster        = module.iam.cluster_role
  iam_role_workernode    = module.iam.worker_role
  cluster_endpoint_cidrs = ["188.30.140.0/24"]

  ami_type       = "AL2023_x86_64_STANDARD"
  instance_types = ["t3.medium"]

  managed_node_groups = {
    default = {
      min_size     = 2
      max_size     = 6
      desired_size = 3
    }
  }
  access_entry = {
    access_entry = {
      cluster_name  = "YoucefEKS-project"
      principal_arn = "arn:aws:iam::418295709007:user/youcef_admin"
      type          = "STANDARD"
      policy_associations = {
        policy_1 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
        policy_2 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

}



module "iam" {
  source            = "./modules/iam.tf"
  cluster_tag       = "iam-cluster-role"
  worker_nodes_tag  = "worker_nodes"
  cluster_role_name = "eks_cluster_role"
  worker_role_name  = "eks_worker_node_role"
}


module "irsa" {
  source                                  = "./modules/irsa.tf"
  oidc_provider_arn                       = module.eks_module.eks_oidc_provider_arn
  hosted_zone_arns                        = ["arn:aws:route53:::hostedzone/Z02736193B0NBZU8BTQQK"]
  cert_manager_role_name                  = "eks-cert-manager-role"
  external_dns_role_name                  = "external_dns_irsa_role"
  cert_manager_role_tag                   = "eks-cert-manager"
  external_dns_role_tag                   = "eks-external-dns"
  cert_namespace_service_accounts         = ["eks-cert-manager:cert-manager"]
  external_dns_namespace_service_accounts = ["eks-external-dns:external-dns"]
}



