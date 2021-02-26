#
# Security Group Creation

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
  cidr_blocks       = ["10.20.0.0/16", "10.2.0.0/16", "172.16.11.0/24", "172.21.21.0/24"]
}

resource "aws_security_group_rule" "icmp_onpremise_inbound_access" {
  from_port         = 0
  protocol          = "icmp"
  security_group_id = aws_security_group.kubernetes_sg.id
  to_port           = 0
  type              = "ingress"
  cidr_blocks       = ["10.20.0.0/16"]
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
  cidr_blocks       = ["10.20.0.0/16", "10.2.0.0/16", "172.16.11.0/24", "172.21.21.0/24"]
}

/***
resource "aws_security_group" "worker_sg" {
  name        = "worker-sg"
  description = "Kubernetes worker security group"
  vpc_id      = aws_vpc.vpc.id
}

# All InBound Access Worker
resource "aws_security_group_rule" "k8s_all_inbound_access" {
  from_port         = 22
  protocol          = "-1"
  security_group_id = aws_security_group.worker_sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = [var.vpc_cidr]
  #cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "kubelet_inbound_access" {
  from_port         = 10250
  protocol          = "tcp"
  security_group_id = aws_security_group.worker_sg.id
  to_port           = 10250
  type              = "ingress"
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group_rule" "nodeport_inbound_access" {
  from_port         = 30000
  protocol          = "tcp"
  security_group_id = aws_security_group.worker_sg.id
  to_port           = 32767
  type              = "ingress"
  cidr_blocks       = [var.vpc_cidr]
}

# All OutBound Access Worker
resource "aws_security_group_rule" "k8s_all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.worker_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  #cidr_blocks       = [var.vpc_cidr]
}
***/
