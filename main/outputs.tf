output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

#output "cka_ip" {
#  value = module.ec2.cka_ip
#}

#output "master_ip" {
#    value = module.ec2.master_ip
#}

#output "woker_ip" {
#   value = module.ec2.worker_ip
#}

#output "eip_nat" {
#    value = module.vpc.aws_eip
#}

#output "vpn_id" {
#  value = module.vpn.vpn_id
#}

output "cluster_endpoint" {
  value       = module.cluster.cluster_endpoint
  description = "Endpoint of the Kubernetes Control Plane."
}

output "cluster_certificate" {
  value       = module.cluster.cluster_certificate
  description = "Certificate used to authenticate to the Kubernetes Controle Plane."
}

output "cluster_name" {
  value       = module.cluster.cluster_name
  description = "Cluster name provided when the cluster was created."
}

output "cluster_id" {
  value = module.cluster.cluster_id
}

output "cluster_kubeconfig" {
  value       = module.cluster.kubeconfig
  description = "Kubernetes configuration file for accessing the cluster using the Kubernete CLI."
}

output "aws_auth" {
  value       = module.workers.aws_auth
  description = "EKS roles"
}

output "eks_admin" {
  value       = module.cluster.eks_admin
  description = "Kubernetes cluster Role"
}