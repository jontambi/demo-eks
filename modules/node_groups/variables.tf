#
# Variables Configuration
#
variable "name" {
  type        = string
  description = "Name to be used on all the EKS Cluster resources as identifier."
}
variable "cluster_name" {}

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

variable "permissions_boundary" {
  default     = ""
  description = "If provided, all IAM roles will be created with this permissions boundary attached."
}




variable "worker_security_group_id" {}

variable "desired_capacity" {
  default     = 2
  description = "Desired capacity of Node Group ASG."
}

variable "min_size" {
  default     = 2
  description = "Minimum size of Node Group ASG."
}

variable "max_size" {
  default     = 2
  description = "Maximum size of Node Group ASG."
}

variable "disk_size" {
  default     = ""
  description = "The root device size for the worker nodes."
}

variable "ami_lookup" {
  default     = ""
  description = "AMI lookup name for the node instances."
}

variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 instance type for the node instances."
}

variable "worker_iam_role_arn" {}
