
output "aws_auth" {
  value       = local.aws_auth
  description = "EKS roles"
}
output "worker_iam_role_arn" {
  value = aws_iam_role.workers.arn
}

