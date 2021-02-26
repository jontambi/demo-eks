locals {
  vpc_id = data.aws_subnet.first.vpc_id
  #ami_id    = var.ami_id != "" ? var.ami_id : data.aws_ami.eks_node.id
  user_data = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint ${var.cluster_endpoint} --b64-cluster-ca ${var.cluster_certificate_authority} ${var.cluster_name}
USERDATA
  aws_auth  = <<AWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.workers.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::361166677709:user/adm_tcs_1
      username: adm_tcs_1
      groups:
        - system:masters
${var.aws_auth}
AWSAUTH
}