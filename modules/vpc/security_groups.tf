#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

# Security Group Creation EC2 Bastion
resource "aws_security_group" "kubernetes_sg" {
  name        = "kubernetes-sg"
  description = "Kubernetes security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-${var.vpc_name}-securityGroup"
  }
}

# Ingress Security Port 22
resource "aws_security_group_rule" "ssh_inbound_access" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.kubernetes_sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "onpremise_inbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.kubernetes_sg.id
  to_port           = 0
  type              = "ingress"
  cidr_blocks       = ["10.20.0.0/16", "10.2.0.0/16", "172.16.11.0/24", "172.21.21.0/24", "10.1.30.0/24"]
}

resource "aws_security_group_rule" "icmp_onpremise_inbound_access" {
  from_port         = 0
  protocol          = "icmp"
  security_group_id = aws_security_group.kubernetes_sg.id
  to_port           = 0
  type              = "ingress"
  cidr_blocks       = ["10.20.0.0/16", "10.1.30.0/24"]
}

resource "aws_security_group_rule" "cluster_ingress_onpremise_https" {
  description       = "Allow workstation to communicate with the cluster API Server"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.kubernetes_sg.id
  cidr_blocks       = ["10.20.0.0/16", "10.1.30.0/24"]
}

# All OutBound Access
resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.kubernetes_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "onpremise_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.kubernetes_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["10.20.0.0/16", "10.2.0.0/16", "172.16.11.0/24", "172.21.21.0/24", "10.1.30.0/24"]
}

# Cluster Security Group

resource "aws_security_group" "cluster" {
  name        = "${var.environment}-${var.vpc_name}-cluster-sg"
  description = "EKS Cluster security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-${var.vpc_name}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_private_access" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["10.20.0.0/16", "10.1.30.0/24"]
  security_group_id = aws_security_group.cluster.id
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  description       = "Allow cluster egress access to the Internet."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "cluster_https_worker_ingress" {
  description              = "Allow pods to communicate with the EKS cluster API."
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.workers.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

# Worker Security Group
resource "aws_security_group" "workers" {
  name        = "${var.environment}-${var.vpc_name}-workers-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    "Name"                                                             = "${var.environment}-${var.vpc_name}-worker-sg"
    "kubernetes.io/cluster/${var.environment}-${var.vpc_name}-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "workers_egress_internet" {
  description       = "Allow nodes all egress to the Internet."
  protocol          = "-1"
  security_group_id = aws_security_group.workers.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "workers_ingress_self" {
  description              = "Allow node to communicate with each other."
  protocol                 = "-1"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.workers.id
  from_port                = 0
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster" {
  description              = "Allow workers pods to receive communication from the cluster control plane."
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 1025
  to_port                  = 65535
  type                     = "ingress"
}

#resource "aws_security_group_rule" "workers_ingress_cluster_kubelet" {
#  description              = "Allow workers Kubelets to receive communication from the cluster control plane."
#  protocol                 = "tcp"
#  security_group_id        = aws_security_group.workers.id
#  source_security_group_id = aws_security_group.cluster.id
#  from_port                = 10250
#  to_port                  = 10250
#  type                     = "ingress"
#}

resource "aws_security_group_rule" "workers_ingress_cluster_https" {
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ssh_private_access" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.20.0.0/16", "10.1.30.0/24"]
  security_group_id = aws_security_group.workers.id
}
