#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#
#
locals {
  ssh_user         = "ec2-user"
  key_name         = "demo"
  private_key_path = "../../credentials/demo.pem"
}

resource "aws_launch_configuration" "workers" {
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.workers.name
  image_id                    = "ami-09d5097f0b2e9bc30"
  #image_id                    = local.ami_id
  instance_type    = var.instance_type
  name_prefix      = "${var.environment}-${var.node_name}-workers"
  key_name         = local.key_name
  security_groups  = flatten([var.worker_security_group_id])
  user_data_base64 = base64encode(local.user_data)
  spot_price       = var.spot_price

  root_block_device {
    volume_size = var.disk_size
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly,
    #aws_iam_role_policy_attachment.workers_additional_policies
  ]
}

resource "aws_autoscaling_group" "workers" {
  launch_configuration = aws_launch_configuration.workers.id
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.environment}-${var.node_name}-worker-asg"
  vpc_zone_identifier  = var.subnet_id

  tag {
    key                 = "Name"
    value               = "${var.environment}-${var.node_name}-workers-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}