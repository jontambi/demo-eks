variable "name" {
  default     = "kubernetes"
  description = "VPC name"
  type        = string
}

variable "customer_name" {
  #default     = "grpgloria"
  default     = "demo"
  type        = string
  description = "Name to be used as customer resource identifier."
}

variable "vpc_cidr" {
  default     = "10.1.30.0/24"
  description = "VPC cidr block"
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = string
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = string
  default     = true
}

variable "private_subnets_cidr" {
  default     = ["10.1.30.16/28", "10.1.30.32/28"]
  description = "A list of VPC private subnet IDs which the nodes are using."
}

variable "public_subnets_cidr" {
  default     = ["10.1.30.128/28"]
  description = "A list of VPC public subnet IDs which the nodes are using."
}

variable "map_public_ip_on_launch" {
  description = "Assign a public IP address to instances launched into the public subnets"
  type        = string
  default     = true
}

variable "azs" {
  default     = ["us-east-1a", "us-east-1b"]
  description = "Available zones"
}

variable "prefix" {
  description = "This is the environment where your cluster is deployed. qa, prod, dev or demo"
}

variable "my_public_key" {
  default = "/mnt/g/Terraform/gloria-aws-services/grpgloria.pem"
}

variable "vpn_connection_static_routes_destinations" {
  description = "List of CIDRs to be used as destination for static routes (used with `vpn_connection_static_routes_only = true`). Routes to destinations set here will be propagated to the routing tables of the subnets defined in `vpc_subnet_route_table_ids`."
  type        = list(any)
  default     = ["172.16.11.0/24", "10.20.0.0/16", "10.2.0.0/16", "172.21.21.0/24"]
}

variable "k8s_version" {
  default     = "1.19"
  description = "Kubernetes version to use for the cluster."
}

variable "enable_kubectl" {
  default     = true
  description = "When enabled, it will merge the cluster's configuration with the one located in ~/.kube/config."
}

variable "enable_dashboard" {
  default     = false
  description = "When enabled, it will install the Kubernetes Dashboard."
}

variable "enable_calico" {
  default     = true
  description = "When enabled, it will install Calico for network policy support."
}

variable "node_name" {
  default     = "workers"
  type        = string
  description = "Unique identifier for the Node Group."
}

variable "node_ami_lookup" {
  default = "AL2_x86_64"
  #default     = "amazon-eks-node-*"
  description = "AMI lookup name for the node instances."
}

variable "node_ami_id" {
  default     = ""
  description = "AMI id for the node instances."
}

variable "node_instance_type" {
  default     = "t2.medium"
  description = "Instance type of the worker node."
}

variable "node_user_data" {
  default     = ""
  description = "Additional user data used when bootstrapping the EC2 instance."
}

variable "node_bootstrap_arguments" {
  default     = ""
  description = "Additional arguments when bootstrapping the EKS node."
}

variable "desired_capacity" {
  default     = 1
  description = "Desired capacity of Node Group ASG."
}

variable "node_min_size" {
  default     = 1
  description = "Minimum size of the worker node AutoScaling Group."
}

variable "node_max_size" {
  default     = 2
  description = "Maximum size of the worker node AutoScaling Group."
}

variable "node_disk_size" {
  default     = 20
  description = "The root device size for the worker nodes."
}

variable "workstation_cidr" {
  default     = ["10.20.20.0/24"]
  description = "CIDR blocks from which to allow inbound traffic to the Kubernetes control plane."
}

variable "key_pair" {
  default     = ""
  description = "Adds an EC2 Key Pair to the cluster nodes."
}

variable "ssh_cidr" {
  default     = "10.20.20.0/24"
  description = "The CIDR blocks from which to allow incoming ssh connections to the EKS nodes."
}
