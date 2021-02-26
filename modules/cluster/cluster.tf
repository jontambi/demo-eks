#
# https://github.com/LukeMwila/aws-eks-platform/blob/master/infra-modules/eks_environment/eks_cluster/eks_cluster.tf
# https://medium.com/dev-genius/create-an-amazon-eks-cluster-with-managed-node-group-using-terraform-a3b50d276b13
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#
# EKS Cluster
resource "aws_eks_cluster" "cluster" {
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  name                      = "${var.environment}-${var.name}-cluster"
  version                   = var.k8s_version
  role_arn                  = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids              = flatten([var.private_subnet_id])
    security_group_ids      = [var.cluster_security_group_id]
    endpoint_private_access = var.cluster_private_access
    endpoint_public_access  = var.cluster_public_access
  }

  kubernetes_network_config {
    service_ipv4_cidr = "192.168.100.0/24"
  }

  depends_on = [
    #    aws_security_group_rule.cluster_egress_internet,
    #    aws_security_group_rule.cluster_https_worker_ingress,
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
    #aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceControllerPolicy,
    #    aws_cloudwatch_log_group.this
  ]
}