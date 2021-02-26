#
# Variables Configuration
#
variable "name" {
  type        = string
  description = "Name to be used on all the EKS Cluster resources as identifier."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where to create the cluster resources."
}

variable "private_subnet_id" {
  #default     = []
  description = "A list of VPC subnet IDs which the cluster uses."
}

variable "k8s_version" {
  description = "Kubernetes version to use for the cluster."
}

variable "environment" {
  description = "This is the environment where your cluster is deployed. qa, prod, or dev"
}

#variable "enable_dashboard" {
#  default     = false
#  description = "When enabled, it will install the Kubernetes Dashboard."
#}

variable "enable_calico" {
  default     = true
  description = "When enabled, it will install Calico for network policy support."
}

#variable "enable_kube2iam" {
#  default     = false
#  description = "When enabled, it will install Kube2IAM to support assigning IAM roles to Pods."
#}

variable "aws_auth" {
  default     = ""
  description = "Grant additional AWS users or roles the ability to interact with the EKS cluster."
}

variable "permissions_boundary" {
  default     = ""
  description = "If provided, all IAM roles will be created with this permissions boundary attached."
}

variable "cluster_private_access" {
  default     = true
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
}

variable "cluster_public_access" {
  default     = false
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
}

variable "cluster_security_group_id" {}