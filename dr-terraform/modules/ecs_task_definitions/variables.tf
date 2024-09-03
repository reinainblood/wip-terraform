# modules/ecs-task-definitions/variables.tf

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ECS services"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID of the security group for the ECS services"
  type        = string
}

variable "target_group_arns" {
  description = "Map of target group ARNs for each service"
  type        = map(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "docdb_connection_string" {
  description = "Connection string for DocumentDB"
  type        = string
}

variable "rds_connection_string" {
  description = "Connection string for RDS"
  type        = string
}

variable "rabbitmq_url" {
  description = "URL template for RabbitMQ"
  type        = string
}

variable "broker_host_template" {
  description = "Template for broker host"
  type        = string
}
variable "service_configs_path" {
  description = "Path to the directory containing service configuration files"
  type        = string
}


variable "s3_bucket_name" {
  description = "Name of the main S3 bucket"
  type        = string
}

variable "reports_s3_bucket" {
  description = "Name of the reports S3 bucket"
  type        = string
}

variable "files_bucket" {
  description = "Name of the files S3 bucket"
  type        = string
}

variable "all_services" {
  description = "Map of all service configurations"
  type = map(object({
    name           = string
    cpu            = number
    memory         = number
    image_tag      = string
    container_port = number
    desired_count  = number
    environment    = list(map(string))
    secrets        = list(map(string))
    health_check   = map(any)
    log_configuration = object({
      logDriver = string
      options   = map(string)
    })
    port_mappings  = list(map(number))
  }))
}

variable "create_alb" {
  description = "List of services that should have an ALB created"
  type        = list(string)
}

