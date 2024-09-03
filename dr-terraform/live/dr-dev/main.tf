# provider "aws" {
#   region = "eu-west-1"  # Or your preferred region for DR
#   profile = "dev"
# }
#
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
# # dr-sandbox/main.tf
#
#
#
#
#
# resource "aws_lb" "services" {
#   for_each = toset(local.lb_services)
#
#   name               = "${var.env_name}-${each.key}-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb[each.key].id]
#   subnets            = var.public_subnet_ids
#
#   tags = merge(var.tags, {
#     Name = "${var.env_name}-${each.key}-lb"
#   })
# }
#
# resource "aws_lb_target_group" "services" {
#   for_each = toset(local.lb_services)
#
#   name        = "${var.env_name}-${each.key}-tg"
#   port        = local.all_services[each.key].container_port
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"
#
#   health_check {
#     path                = "/health"
#     healthy_threshold   = 2
#     unhealthy_threshold = 10
#     timeout             = 60
#     interval            = 300
#     matcher             = "200"
#   }
#
#   tags = merge(var.tags, {
#     Name = "${var.env_name}-${each.key}-tg"
#   })
# }
#
# resource "aws_lb_listener" "http" {
#   for_each = toset(local.lb_services)
#
#   load_balancer_arn = aws_lb.services[each.key].arn
#   port              = 80
#   protocol          = "HTTP"
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.services[each.key].arn
#   }
# }
#
# resource "aws_security_group" "lb" {
#   for_each = toset(local.lb_services)
#
#   name        = "${var.env_name}-${each.key}-lb-sg"
#   description = "Security group for ${each.key} load balancer"
#   vpc_id      = var.vpc_id
#
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = merge(var.tags, {
#     Name = "${var.env_name}-${each.key}-lb-sg"
#   })
# }
#
#
# module "ecs_task_definitions" {
#   source = "../../modules/ecs-task-definitions"
#
#   env_name            = var.env_name
#   cluster_id          = module.ecs.cluster_id
#   execution_role_arn  = var.ecs_task_execution_role_arn
#   task_role_arn       = var.ecs_task_role_arn
#   ecr_repository_url  = var.ecr_repository_url
#   subnet_ids          = var.private_subnet_ids
#   security_group_id   = aws_security_group.ecs_services.id
#
#   target_group_arns   = {
#     for k in local.lb_services : k => aws_lb_target_group.services[k].arn
#   }
#
#   services = local.all_services
#
#   tags = var.tags
# }
#
# resource "aws_security_group" "ecs_services" {
#   name        = "${var.env_name}-ecs-services"
#   description = "Security group for ECS services"
#   vpc_id      = var.vpc_id
#
#   dynamic "ingress" {
#     for_each = aws_security_group.lb
#     content {
#       from_port       = 0
#       to_port         = 0
#       protocol        = "-1"
#       security_groups = [ingress.value.id]
#     }
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = var.tags
# }
#
# # Outputs remain the same
#
# # data "external" "latest_image_tags" {
# #   for_each = var.services
# #   program = ["bash", "${path.module}/get_latest_image.sh", each.key, var.aws_region, var.account_id, var.ecr_repository_name]
# # }
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
# # }