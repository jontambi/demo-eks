
# Provider Configuration
#

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28.0"
    }
  }
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}
# Not required: currently used in conjuction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}

/***
data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_id
}

provider "kubernetes" {
  host                   = module.cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.cluster.cluster_certificate)
  token                  = data.aws_eks_auth.cluster.token
  load_config_file       = false
  #version                = "2.0.2"
}

***/
