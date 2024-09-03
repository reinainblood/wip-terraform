provider "aws" {
  region = var.aws_region
  profile = "devops-testing"
}

data "aws_caller_identity" "current" {}
# Use a data source to fetch the role ARN

module "iam" {
  source = "../../modules/iam"
  account_id = var.account_id
}

data "aws_iam_role" "terraform_runner" {
  name = module.iam.terraform_runner_role_name
  depends_on = [module.iam]
}

provider "aws" {
  alias  = "assumed_role"
  region = var.region

  assume_role {
    role_arn = data.aws_iam_role.terraform_runner.arn
  }
}
module "shared_kms_key" {
  source   = "../../modules/kms"
  key_name = "custom_key_for_shared_snapshots"
  parent_account_id = var.parent_account_id
  account_id = var.account_id
}



module "vpc" {
  source = "../../modules/vpc"

  env = var.env
  enable_nat_gateway = true
  single_nat_gateway = false
}



## start of copied code
# locals {
#   docdb_url = "${module.docdb.cluster_endpoint}:27017"
# }
# module "docdb" {
#   source = "../../modules/documentdb"
#
#   cluster_identifier     = var.docdb_cluster_identifier
#   master_username        = var.docdb_username
#   master_password        = var.docdb_password
#   snapshot_identifier    = var.docdb_snapshot_identifier
#   instance_count         = var.docdb_instance_count
#   instance_class         = var.docdb_instance_class
#   vpc_security_group_ids = var.docdb_vpc_security_group_ids
#   db_subnet_group_name   = var.docdb_subnet_group_name
# }
#
# # retrieve newly stored docdb secret
# data "aws_secretsmanager_secret" "docdb_connection_string" {
#   name = "dr-sandbox-docdb-connection-string"
# }
#
# data "aws_secretsmanager_secret_version" "docdb_connection_string" {
#   docdb_connection_string = data.aws_secretsmanager_secret_version.docdb_connection_string.secret_string
# }
# locals {
#   docdb_connection_string = data.aws_secretsmanager_secret_version.docdb_connection_string.secret_string
# }
#
# module "rds" {
#   source = "../../modules/rds"
#   rds_cluster_snapshot_identifier = var.rds_cluster_snapshot_identifier
#   rds_cluster_identifier = "sandbox-dr-postgres"
#   db_subnet_group_name = var.rds_subnet_group_name
#   master_username             = var.postgres_username
#   master_password             = var.postgres_password
#   rds_vpc_security_group_ids  = var.rds_vpc_security_group_ids
# }
# data "aws_secretsmanager_secret_version" "rds_connection_string" {
#   rds_connection_string = data.aws_secretsmanager_secret_version.rds_connection_string.secret_string
# }
# locals {
#   rds_connection_string = data.aws_secretsmanager_secret_version.rds_connection_string.secret_string
# }
#
# module "rabbitmq" {
#   source = "../../modules/amazon_mq"
#   broker_name   = var.broker_name
#   host_instance_type = var.host_instance_type
#   users_file    = var.users_file
#   rabbitmq_admin_password = var.rabbitmq_admin_password
# }
#
# # module "elasticache_redis" {
# #   source = "../../modules/elasticache_redis"
# #
# #   cluster_id = "sandbox-dr-redis"
# #   node_type  = "cache.t3.micro"
# # }
# provider "postgresql" {
#   scheme    = "awspostgres"
#   host      = module.rds.db_instance_endpoint
#   port      = 5432
#   username  = var.master_username
#   password  = var.master_password
#   superuser = false
# }
#
# resource "random_password" "db_passwords" {
#   for_each = var.services
#   length   = 16
#   special  = false
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }
#
# resource "postgresql_role" "service_db_roles" {
#   for_each            = var.services
#   name                = "${each.key}-role"
#   login               = true
#   password            = random_password.db_passwords[each.key].result
#   encrypted_password  = true
# }
#
# resource "postgresql_database" "service_dbs" {
#   for_each          = var.services
#   name              = each.key
#   owner             = postgresql_role.service_db_roles[each.key].name
#   template          = "template0"
#   lc_collate        = "C"
#   connection_limit  = -1
#   allow_connections = true
# }
#
# # Store the database credentials in AWS Secrets Manager
# resource "aws_secretsmanager_secret" "db_credentials" {
#   for_each = var.services
#   name     = "dr-sandbox-${each.key}-db-credentials"
# }
#
# resource "aws_secretsmanager_secret_version" "db_credentials" {
#   for_each      = var.services
#   secret_id     = aws_secretsmanager_secret.db_credentials[each.key].id
#   secret_string = jsonencode({
#     username = postgresql_role.service_db_roles[each.key].name
#     password = random_password.db_passwords[each.key].result
#     database = postgresql_database.service_dbs[each.key].name
#     host     = module.rds.db_instance_endpoint
#     port     = 5432
#   })
# }
#
# module "ecs" {
#   source = "../../modules/ecs"
#
#   aws_region                   = var.aws_region
#   cluster_name                 = var.cluster_name
#   ecs_task_execution_role_arn  = var.ecs_task_execution_role_arn
#   ecs_task_role_arn            = var.ecs_task_role_arn
#   ecr_repository_url           = var.ecr_repository_url
#   subnet_ids                   = var.subnet_ids
#   ecs_tasks_security_group_id  = var.ecs_tasks_security_group_id
#   service_discovery_namespace  = var.service_discovery_namespace
#   vpc_id                       = var.vpc_id
#   docdb_connection_string = local.docdb_connection_string
#   services = {
#     for name, config in var.services :
#     name => merge(config, {
#       image_tag = data.external.latest_image_tags[name].result.image_tag
#     })
#   }
# }
#
# data "external" "latest_image_tags" {
#   for_each = var.services
#   program = ["bash", "${path.module}/get_latest_image.sh", each.key, var.aws_region, var.account_id, var.ecr_repository_name]
# }
#
# # module "ecs_cluster" {
# #   source = "../../modules/ecs_cluster"
# #
# #   cluster_name             = "sandbox-dr-cluster"
# #   app_count                = 1
# #   ecs_task_security_groups = var.ecs_task_security_groups
# #   subnet_ids               = var.subnet_ids
# #   pricing_svc_image        = var.pricing_svc_image
# #   iam_svc_image            = var.iam_svc_image
# #   redis_url                = module.elasticache_redis.cache_nodes[0].address
# #   rabbitmq_url             = var.rabbitmq_url  # You'll need to construct this from the Amazon MQ output
# #   doc_db_url               = module.documentdb.cluster_endpoint
# #   # Add other variables for service images and environment variables
# }