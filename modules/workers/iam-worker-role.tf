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
# Worker Role
resource "aws_iam_role" "workers" {
  name                  = "${var.environment}-${var.node_name}-EksWorkerRole"
  assume_role_policy    = data.aws_iam_policy_document.worker_assume_role.json
  permissions_boundary  = var.permissions_boundary
  force_detach_policies = true
}

data "aws_iam_policy_document" "worker_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workers.name
}


resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_instance_profile" "workers" {
  name = "${var.environment}-${var.node_name}-IamNodeRole"
  role = aws_iam_role.workers.name

}

data "aws_iam_policy_document" "worker_pv_role_creation" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "workers_pv_role_creation" {
  name_prefix = "${var.environment}-${var.node_name}-PvRoleCreation"
  role        = aws_iam_role.workers.name
  policy      = data.aws_iam_policy_document.worker_pv_role_creation.json
}
