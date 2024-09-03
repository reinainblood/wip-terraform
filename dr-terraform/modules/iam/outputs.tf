output "terraform_runner_role_arn" {
  value       = aws_iam_role.terraform_runner.arn
  description = "ARN of the Terraform Runner role"
}
output "terraform_runner_role_name" {
  value       = aws_iam_role.terraform_runner.name
  description = "Name of the Terraform Runner role"
}
