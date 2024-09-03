output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.this.arn
}

# Optionally, if you want to output the task definition revision
output "task_definition_revision" {
  description = "Revision of the task definition"
  value       = aws_ecs_task_definition.this.revision
}
output "ecs_task_role_arn" {
  description = "ARN of the ECS Task Role"
  value       = aws_iam_role.ecs_task_role.arn
}
