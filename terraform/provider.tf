terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.79.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.6"
    }
  }

  backend "s3" {
    bucket  = "eks-bucket2233"
    key     = "terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}




provider "aws" {
  region = "eu-west-2"
}

provider "helm" {
  kubernetes {
    host                   = module.eks_module.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_module.eks_cert_authority)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks_module.eks_cluster_name]
      command     = "aws"
    }
  }
}

