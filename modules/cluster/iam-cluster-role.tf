#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services

# Cluster Role
resource "aws_iam_role" "cluster" {
  name                  = "${var.environment}-${var.name}-EksClusterRole"
  assume_role_policy    = data.aws_iam_policy_document.cluster_assume_role.json
  permissions_boundary  = var.permissions_boundary
  force_detach_policies = true
}

data "aws_iam_policy_document" "cluster_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

/*
 Adding a policy to cluster IAM role that allow permissions
 required to create AWSServiceRoleForElasticLoadBalancing service-linked role by EKS during ELB provisioning

data "aws_iam_policy_document" "cluster_elb_sl_role_creation" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeInternetGateways",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cluster_elb_sl_role_creation" {
  name_prefix = "${var.environment}-${var.name}-ElbSlRoleCreation"
  role        = aws_iam_role.cluster.name
  policy      = data.aws_iam_policy_document.cluster_elb_sl_role_creation.json
}

*/
