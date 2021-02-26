
#https://itnext.io/build-an-eks-cluster-with-terraform-d35db8005963
#https://www.fairwinds.com/blog/terraform-and-eks-a-step-by-step-guide-to-deploying-your-first-cluster
#VPC - NAT GATEWAY
#https://github.com/claranet/terraform-aws-vpc-modules/blob/v1.1.0/main.tf

#VPN - Site to Site
#https://dev.to/jonatasbaldin/terraform-for-a-highly-available-vpn-between-aws-and-azure-39j5

module "vpc" {
  source                  = "../modules/vpc"
  vpc_name                = var.name
  environment             = var.prefix
  vpc_cidr                = var.vpc_cidr
  enable_dns_support      = var.enable_dns_support
  enable_dns_hostnames    = var.enable_dns_hostnames
  map_public_ip_on_launch = var.map_public_ip_on_launch

  private_subnets_cidr                      = var.private_subnets_cidr
  public_subnets_cidr                       = var.public_subnets_cidr
  #vpn_gateway_id                            = module.vpn.vpn_gateway_id
  #vpn_connection_static_routes_destinations = var.vpn_connection_static_routes_destinations
  azs                                       = var.azs
}

/***
module "vpn" {
  source                                    = "../modules/vpn"
  vpc_id                                    = module.vpc.vpc_id
  environment                               = var.prefix
  customer_name                             = var.customer_name
  vpn_connection_static_routes_destinations = var.vpn_connection_static_routes_destinations
  public_route_table_id                     = module.vpc.public_route_table_id
  private_route_table_id                    = module.vpc.private_route_table_id
}
***/

module "ec2" {
  source                = "../modules/ec2"
  vpc_name              = var.name
  environment           = var.prefix
  azs                   = var.azs
  public_subnet_id      = module.vpc.public_subnet_id
  my_public_key         = var.my_public_key
  master_security_group = module.vpc.kubernetes_security_group_id

  depends_on = [
    module.vpc
  ]
}

module "cloudwatch" {
  source = "../modules/cloudwatch"
  #vpn_id      = module.vpn.vpn_id
  name        = var.name
  environment = var.prefix

}

module "cluster" {
  source                    = "../modules/cluster"
  name                      = var.name
  k8s_version               = var.k8s_version
  vpc_id                    = module.vpc.vpc_id
  environment               = var.prefix
  cluster_security_group_id = module.vpc.cluster_security_group_id
  enable_calico             = var.enable_calico
  private_subnet_id         = module.vpc.private_subnet_id

  depends_on = [
    module.vpc.cluster_security_group_id,
    module.cloudwatch,
  ]
}

module "workers" {
  source                        = "../modules/workers"
  node_name                     = var.name
  cluster_name                  = module.cluster.cluster_name
  environment                   = var.prefix
  cluster_endpoint              = module.cluster.cluster_endpoint
  cluster_certificate_authority = module.cluster.cluster_certificate
  worker_security_group_id      = [module.vpc.worker_security_group_id]
  subnet_id                     = flatten([module.vpc.private_subnet_id])
  #ami_lookup                    = var.node_ami_lookup
  instance_type    = var.node_instance_type
  desired_capacity = var.desired_capacity
  min_size         = var.node_min_size
  max_size         = var.node_max_size
  disk_size        = var.node_disk_size

  depends_on = [
    module.vpc.workers_egress_internet,
    module.vpc.workers_ingress_self,
    module.vpc.workers_ingress_cluster,
    module.vpc.workers_ingress_cluster_kubelet,
    module.vpc.workers_ingress_cluster_https,
    module.cluster
  ]
}

/***
module "node_groups" {
  source                   = "../modules/node_groups"
  name                     = var.name
  cluster_name             = module.cluster.cluster_name
  vpc_id                   = module.vpc.vpc_id
  k8s_version              = var.k8s_version
  environment              = var.prefix
  worker_security_group_id = module.vpc.worker_security_group_id
  private_subnet_id        = module.vpc.private_subnet_id
  desired_capacity         = var.desired_capacity
  min_size                 = var.node_min_size
  max_size                 = var.node_max_size
  disk_size                = var.node_disk_size
  ami_lookup               = var.node_ami_lookup
  instance_type            = var.node_instance_type
  worker_iam_role_arn      = module.workers.worker_iam_role_arn

  depends_on = [
    module.cluster,
    module.workers.worker_iam_role_arn,
  ]
}
***/
