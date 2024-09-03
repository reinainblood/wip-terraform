variable "docdb_username" {
  type = string
}

variable "docdb_password" {
  type = string
}

variable "docdb_cluster_identifier" {
  type = string
}
#s3 vars
variable "source_region" {
  description = "The region where the source buckets are located"
  type        = string
}

variable "destination_region" {
  description = "The region where the destination buckets should be created"
  type        = string
}
variable "docdb_secret_name" {
  type        = string
  description = "Name of the secret in AWS Secrets Manager that contains the DocDB connection string"
}

variable "create_docdb" {
  type        = bool
  description = "Whether to create a new DocDB cluster or use an existing one"
  default     = false
}
variable "docdb_connection_string" {
  type = string
  description = "Retrieved from secrets manager, string for connection to documentdb"
}
variable "docdb_snapshot_identifier" {
  type = string
  description = "The identifier for the DB snapshot or DB cluster snapshot to restore from."
}

variable "docdb_instance_count" {
  type    = number
  default = 1
}

variable "docdb_instance_class" {
  type = string
}

variable "docdb_vpc_security_group_ids" {
  type = list(string)
}

variable "docdb_subnet_group_name" {
  type = string
}
variable "postgres_username" {
  type = string
}

variable "postgres_password" {
  type = string
}

variable "rds_cluster_snapshot_identifier" {
  type = string
}

variable "rds_subnet_group_name" {
  type = string
}
variable "rds_vpc_security_group_ids" {
  type = list(string)
}
# RabbitMq vars
variable "users_file" {
  type        = string
  description = "Path to the JSON file containing user data for RabbitMQ"
}
variable "broker_name" {
  type = string
  description = "Name for RabbitMQ broker"
}
variable "host_instance_type" {
  type = string
  description = "Instance type for single instance RabbitMQ setup"
}
variable "rabbitmq_admin_password" {
  type = string
  description = "The password for the initial admin user for RabbitMQ"
}
variable "aws_region" {
  description = "The AWS region to create resources in"
}
variable "account_id" {
  description = "AWS account ID"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
}
variable "cluster_name" {
  description = "The name of the ECS cluster"
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
}

variable "env_name" {
  type        = string
  description = "Environment name (e.g., sandbox, production)"
}



variable "rds_connection_string" {
  type        = string
  description = "RDS connection string"
}

variable "broker_host_template" {
  type        = string
  default     = "https://%s.broker.assetreality.org"
  description = "Template for the broker host URL"
}

variable "vpc_id" {
  description = "The VPC ID where the services will run"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs for the ECS services"
  type        = list(string)
}
variable "public_subnet_ids" {
  description = "List of public subnets in the VPC"
  type = list(string)
}
variable "private_subnet_ids" {
  description = "List of private subnets in the VPC"
  type = list(string)
}
variable "ecs_tasks_security_group_id" {
  description = "ID of the security group for ECS tasks"
}


variable "s3_bucket_name" {
  description = "Name of the main S3 bucket"
  type        = string
  default = "dr-sandbox-amrs-files"
}

variable "reports_s3_bucket" {
  description = "Name of the reports S3 bucket"
  type        = string
  default = "dr-sandbox-ar-amrs-reports-exports"
}

variable "files_bucket" {
  description = "Name of the files S3 bucket"
  type        = string
  default = "dr-sandbox-ar-files"
}

variable "temp_redis_connection_string" {
  type = string
  default = "redis://default:@dr-sandbox-redis-2bolip.serverless.euw3.cache.amazonaws.com:6379"
}
variable "ecs_cluster_tags" {
  description = "A map of tags to add to ecs cluster"
  type        = map(string)
  default     = {"env": "dr-sandbox"}
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# variable "ecs_task_security_groups" {
#   type = list(string)
# }
#
# variable "subnet_ids" {
#   type = list(string)
# }
#
# variable "pricing_svc_image" {
#   type = string
# }
#
# variable "iam_svc_image" {
#   type = string
# }
#
variable create_alb {
  description = "List of services to create ALBs for"
  type = list(string)
}
variable "rabbitmq_url" {
  type = string
}
#
# # Add other variables as needed