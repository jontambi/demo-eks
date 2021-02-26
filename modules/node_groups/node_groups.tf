resource "aws_eks_node_group" "workers" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.environment}-${var.name}-workers"
  node_role_arn   = var.worker_iam_role_arn
  ami_type        = var.ami_lookup
  instance_types  = [var.instance_type]
  capacity_type   = "ON_DEMAND"
  disk_size       = var.disk_size
  subnet_ids      = flatten([var.private_subnet_id])
  version         = var.k8s_version

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  remote_access {
    ec2_ssh_key               = local.key_name
    source_security_group_ids = [var.worker_security_group_id]
  }

  tags = {
    Name = "${var.environment}-${var.name}-workers"
  }
}
