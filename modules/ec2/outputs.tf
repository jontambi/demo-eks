output "bastion_ip" {
  value = aws_instance.bastion[*].private_ip
}

#output "worker_ip" {
#    value = aws_instance.worker_server[*].private_ip
#}
