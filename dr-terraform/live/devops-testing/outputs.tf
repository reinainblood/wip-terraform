output "terraform_runner_role_arn" {
  value       = module.iam.terraform_runner_role_arn

}
output "terraform_runner_role_name" {
  value       = module.iam.terraform_runner_role_name
  description = "Name of the Terraform Runner role"
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
output "shared_kms_key_arn" {
  value       = module.shared_kms_key.key_arn
  description = "The ARN of the shared KMS key"
}

output "shared_kms_key_id" {
  value       = module.shared_kms_key.key_id
  description = "The ID of the shared KMS key"
}


