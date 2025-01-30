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
  iamrole_cluster     = module.iam.cluster_role
  iam_role_workernode = module.iam.worker_role
   access_entry = {
   access_entry = {
       cluster_name  = "YoucefEKS-project"
       principal_arn = "arn:aws:iam::418295709007:user/youcef_admin"
       type          = "STANDARD"
    policy_associations = {
        policy_1 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
        policy_2 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
   }
}
}



module "iam" {
  source      = "./modules/iam.tf"
  cluster_tag = "iam-cluster-role"
}


module "irsa" {
  source            = "./modules/irsa.tf"
  oidc_provider_arn = module.eks_module.eks_oidc_provider_arn


}



