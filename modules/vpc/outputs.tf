output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}


output "kubernetes_security_group_id" {
  value = aws_security_group.kubernetes_sg.id
}

output "cluster_security_group_id" {
  value       = aws_security_group.cluster.id
  description = "Security group ID attached to the EKS cluster. On 1.14 or later, this is the 'Additional security groups' in the EKS console."
}

output "cluster_https_worker_ingress" {
  value = aws_security_group_rule.cluster_https_worker_ingress
}

output "worker_security_group_id" {
  value       = aws_security_group.workers.id
  description = "Security group ID attached to the EKS workers."
}
output "workers_egress_internet" {
  value = aws_security_group_rule.workers_egress_internet
}
output "workers_ingress_self" {
  value = aws_security_group_rule.workers_ingress_self
}
output "workers_ingress_cluster" {
  value = aws_security_group_rule.workers_ingress_cluster
}
#output "workers_ingress_cluster_kubelet" {
#  value = aws_security_group_rule.workers_ingress_cluster_kubelet
#}
output "workers_ingress_cluster_https" {
  value = aws_security_group_rule.workers_ingress_cluster_https
}

#output "cluster_primary_ingress_workers" {
#  value = aws_security_group_rule.cluster_primary_ingress_workers
#}
