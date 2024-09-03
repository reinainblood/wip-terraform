variable "env" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}
 variable "account_id" {
   type = string
   description = "AWS account ID"
 }
variable "parent_account_id" {
  type = number
  description = "Account ID of the aws account we are bootstrapping from"
  default = "801786578069"
}
variable "aws_region" {
  type = string
  default = "eu-central-1"
}
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}
variable "parent" {
  description = "parent aws account of tgw"
  default = "dev"
  type = string
}

variable "tgw_id" {
  description = "id of tgw in parent account"
  type = string
  default = "tgw-069d24b13e88f7a38"

}
variable "tgw_subnet_count" {
  description = "Number of subnets to create for TGW attachment"
  type        = number
  default = 3
}

variable "db_subnet_count" {
  description = "Number of subnets to create for databases"
  type        = number
  default = 3
}

variable "ecs_subnet_count" {
  description = "Number of subnets to create for ECS cluster"
  type        = number
  default = 3
}



#
#
# variable "docdb_username" {
#   type = string
# }
#
# variable "docdb_password" {
#   type = string
# }
#
# variable "docdb_cluster_identifier" {
#   type = string
# }
#
# variable "docdb_connection_string" {
#   type = string
#   description = "Retrieved from secrets manager, string for connection to documentdb"
# }
# variable "docdb_snapshot_identifier" {
#   type = string
#   description = "The identifier for the DB snapshot or DB cluster snapshot to restore from."
# }
#
# variable "docdb_instance_count" {
#   type    = number
#   default = 1
# }
#
# variable "docdb_instance_class" {
#   type = string
# }
#
# variable "docdb_vpc_security_group_ids" {
#   type = list(string)
# }
#
# variable "docdb_subnet_group_name" {
#   type = string
# }
# variable "postgres_username" {
#   type = string
# }
#
# variable "postgres_password" {
#   type = string
# }
#
# variable "rds_cluster_snapshot_identifier" {
#   type = string
# }
#
# variable "rds_subnet_group_name" {
#   type = string
# }
# variable "rds_vpc_security_group_ids" {
#   type = list(string)
# }
# # RabbitMq vars
# variable "users_file" {
#   type        = string
#   description = "Path to the JSON file containing user data for RabbitMQ"
# }
# variable "broker_name" {
#   type = string
#   description = "Name for RabbitMQ broker"
# }
# variable "host_instance_type" {
#   type = string
#   description = "Instance type for single instance RabbitMQ setup"
# }
# variable "rabbitmq_admin_password" {
#   type = string
#   description = "The password for the initial admin user for RabbitMQ"
# }
# variable "aws_region" {
#   description = "The AWS region to create resources in"
# }
#
#
# variable "ecr_repository_name" {
#   description = "Name of the ECR repository"
# }
# variable "cluster_name" {
#   description = "The name of the ECS cluster"
# }
#
# variable "ecs_task_execution_role_arn" {
#   description = "ARN of the ECS task execution role"
# }
#
# variable "ecs_task_role_arn" {
#   description = "ARN of the ECS task role"
# }
#
# variable "ecr_repository_url" {
#   description = "URL of the ECR repository"
# }
# variable "service_discovery_namespace" {
#   description = "The namespace to use for service discovery"
#   type        = string
# }
# variable "common_environment_variables" {
#   description = "Common environment variables for all services"
#   type = list(object({
#     name  = string
#     value = string
#   }))
# }
# variable "vpc_id" {
#   description = "The VPC ID where the services will run"
#   type        = string
# }
# variable "subnet_ids" {
#   description = "List of subnet IDs for the ECS services"
#   type        = list(string)
# }
#
# variable "ecs_tasks_security_group_id" {
#   description = "ID of the security group for ECS tasks"
# }
#
# variable "services" {
#   description = "Map of services with their configurations"
#   type = map(object({
#     cpu            = number
#     memory         = number
#     image_tag      = string
#     container_port = number
#     desired_count  = number
#     environment    = list(map(string))
#     secrets        = list(map(string))
#   }))
# }
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
# variable "rabbitmq_url" {
#   type = string
# }
#
# # Add other variables as needed