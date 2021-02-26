output "cluster_iam_role_name" {
  value = aws_iam_role.cluster.name
}
output "cluster_iam_role_arn" {
  value = aws_iam_role.cluster.arn
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.cluster.endpoint
  description = "Endpoint of the Kubernetes Control Plane."
}

output "cluster_certificate" {
  value       = aws_eks_cluster.cluster.certificate_authority.0.data
  description = "Certificate used to authenticate to the Kubernetes Controle Plane."
}

output "cluster_name" {
  value       = aws_eks_cluster.cluster.name
  description = "Cluster name provided when the cluster was created."
}

output "cluster_id" {
  value       = aws_eks_cluster.cluster.id
  description = ""
}

output "kubeconfig" {
  value       = local.kubeconfig
  description = "Kubernetes configuration file for accessing the cluster using the Kubernete CLI."
}

#output "aws_auth" {
#  value       = local.aws_auth
#  description = "EKS roles"
#}

output "eks_admin" {
  value       = local.eks_admin
  description = "Kubernetes cluster Role"

}