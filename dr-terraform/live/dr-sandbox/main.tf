terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = var.source_region
  alias   = "source"
  profile = "sandbox"
}

# provider "aws" {
#   region  = var.destination_region
#   alias   = "destination"
#   profile = "sandbox"
# }

# main.tf

# data "aws_secretsmanager_secret" "docdb" {
#   name = "${var.env_name}-DOCDB-SECRET"  # Adjust this name as needed
# }
#
# data "aws_secretsmanager_secret_version" "docdb" {
#   secret_id = data.aws_secretsmanager_secret.docdb.id
# }
# hardcoding this for ecs testing
# locals {
#   docdb_connection_string = jsondecode(data.aws_secretsmanager_secret_version.docdb.secret_string)["${var.env_name}-DOCDB-BASE-URL"]
# }


module "docdb" {
  count  = var.create_docdb ? 1 : 0
  source = "../../modules/documentdb"
  cluster_identifier     = var.docdb_cluster_identifier
  master_username        = var.docdb_username
  master_password        = var.docdb_password
  snapshot_identifier    = var.docdb_snapshot_identifier
  instance_count         = var.docdb_instance_count
  instance_class         = var.docdb_instance_class
  vpc_security_group_ids = var.docdb_vpc_security_group_ids
  db_subnet_group_name   = var.docdb_subnet_group_name
}

module "rds" {
  source = "../../modules/rds"
  rds_cluster_snapshot_identifier = var.rds_cluster_snapshot_identifier
  rds_cluster_identifier = "sandbox-dr-postgres"
  db_subnet_group_name = var.rds_subnet_group_name
  master_username             = var.postgres_username
  master_password             = var.postgres_password
  rds_vpc_security_group_ids  = var.rds_vpc_security_group_ids
  env_name = var.env_name
}

data "aws_secretsmanager_secret" "rds_connection_string" {
  name = "${var.env_name}-postgres-ecs-users-creds"  # Replace with your actual secret name
}

# fetch the secret value
data "aws_secretsmanager_secret_version" "rds_connection_string" {
  secret_id = data.aws_secretsmanager_secret.rds_connection_string.id
}
# hardcoding this for ecs testing
# Now we can use the secret value in a local variable
# locals {
#   rds_connection_string = data.aws_secretsmanager_secret_version.rds_connection_string.secret_string
# }

module "rabbitmq" {
  source = "../../modules/amazon_mq"
  broker_name   = var.broker_name
  host_instance_type = var.host_instance_type
  users_file    = var.users_file
  rabbitmq_admin_password = var.rabbitmq_admin_password
}

# module "elasticache_redis" {
#   source = "../../modules/elasticache_redis"
#
#   cluster_id = "sandbox-dr-redis"
#   node_type  = "cache.t3.micro"
# }

# Data source to get all S3 buckets in the source region
# data "aws_s3_bucket" "all" {}
# # Local variable to filter out buckets with "codepline" in the name
# locals {
#   filtered_buckets = [
#     for bucket in data.aws_s3_buckets.all.buckets :
#     bucket if !contains(split("-", bucket), "codepline")
#   ]
# }


# Module call for each filtered bucket
# module "s3_bucket_copy" {
#   source   = "../../modules/replicated_s3/same_region"
#   for_each = toset(local.filtered_buckets)

  # uncomment this for cross-region copy
#   providers = {
#     aws.source      = aws
#     aws.destination = aws.destination
#   }
#
#   source_region         = var.source_region
#   destination_region    = var.destination_region
#   source_bucket_name    = each.key
#   destination_bucket_name = "dr-${each.key}"
# }

# dr-sandbox/main.tf

module "ecs" {
  source   = "../../modules/ecs"
  env_name = var.env_name
  tags     = var.ecs_cluster_tags
  vpc_id = var.vpc_id
}
data "aws_service_discovery_dns_namespace" "this" {
  name = module.ecs.service_discovery_namespace
  type = "DNS_PRIVATE"
}

# Load balancers
locals {
  lb_services = ["auth", "broker", "governance"]
}
module "alb" {
  source = "../../modules/alb"

  env_name          = var.env_name
  lb_services       = local.lb_services
  vpc_id            = var.vpc_id
  public_subnet_ids = var.public_subnet_ids

  tags = var.tags
}
resource "aws_lb_target_group" "services" {
  for_each = toset(local.lb_services)

  name        = "${var.env_name}-${each.key}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200"
  }

  tags = var.tags
}
resource "aws_lb_listener" "http" {
  for_each = module.alb.alb_arns

  load_balancer_arn = each.value
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services[each.key].arn
  }
}

# ECS Task defs
# locals {
#   services_config = templatefile("${path.module}/service_configs/_services.tf", {
#
#     env_name = var.env_name
#     aws_region = var.aws_region
#     broker_host_templat = var.broker_host_template
#     s3_bucket_name = var.s3_bucket_name
#     files_bucket = var.files_bucket
#     reports_s3_bucket = var.reports_s3_bucket
#     docdb_connection_string = var.docdb_connection_string
#     rds_connection_string = var.rds_connection_string
#     rabbitmq_url = var.rabbitmq_url
#     temp_redis_connection_string = var.temp_redis_connection_string
#
#
#
#   })



# build task definitions from service configs directory
# main.tf

locals {
  services_config_template = templatefile("${path.module}/service_configs/_services.tf", {
    env_name = var.env_name
    broker_host_template = var.broker_host_template
    s3_bucket_name = var.s3_bucket_name
    files_bucket = var.files_bucket
    reports_s3_bucket = var.reports_s3_bucket
    docdb_connection_string = var.docdb_connection_string
    rds_connection_string = var.rds_connection_string
    rabbitmq_url = var.rabbitmq_url
    temp_redis_connection_string = var.temp_redis_connection_string
  })

  services_config = jsondecode(local.services_config_template)

  service_files = fileset("${path.module}/service_configs", "*.tf")

  service_configs = {
    for file in local.service_files :
    file => jsondecode(templatefile("${path.module}/service_configs/${file}", {
      env_name = var.env_name
      aws_region = var.aws_region
    }))
    if file != "_services.tf"
  }

  all_services = {
    for file, config in local.service_configs :
    config.locals[keys(config.locals)[0]].name => merge(config.locals[keys(config.locals)[0]], {
      environment = concat(
        local.services_config.common_environment_variables,
        try(config.locals[keys(config.locals)[0]].environment, [])
      ),
      secrets = concat(
        try(config.locals[keys(config.locals)[0]].secrets, []),
        local.services_config.common_secrets
      )
    })
  }
}

module "ecs_task_definitions" {
  source = "../../modules/ecs_task_definitions"
  all_services = local.all_services
  env_name               = var.env_name
  cluster_id             = module.ecs.cluster_id
  execution_role_arn     = var.ecs_task_execution_role_arn
  task_role_arn          = var.ecs_task_role_arn
  ecr_repository_url     = var.ecr_repository_url
  subnet_ids             = var.private_subnet_ids
  security_group_id      = aws_security_group.ecs_services.id
  docdb_connection_string = var.docdb_connection_string
  rds_connection_string   = var.rds_connection_string
  rabbitmq_url            = var.rabbitmq_url
  service_configs_path    = "/service_configs"
  broker_host_template    = var.broker_host_template
  s3_bucket_name          = var.s3_bucket_name
  reports_s3_bucket       = var.reports_s3_bucket
  files_bucket            = var.files_bucket
  create_alb = var.create_alb

  target_group_arns = {
    for k in local.lb_services : k => aws_lb_target_group.services[k].arn
  }

  tags = var.tags
}

resource "aws_security_group" "ecs_services" {
  name        = "${var.env_name}-ecs-services"
  description = "Security group for ECS services"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = values(module.alb.security_group_ids)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}



# Create an IAM role for ECS task execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.env_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the ECS execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



