# # dr-sandbox/locals.tf
#
# locals {
#
#   initial_service_discovery_namespace = "${var.env_name}.local"
#   service_discovery_namespace = data.aws_service_discovery_dns_namespace.this.name
#
#
#   service_ports = {
#     account             = 5999
#     amrs                = 5000
#     auth                = 5001
#     blockchain          = 5777
#     broker              = 5002
#     custodian           = 8565
#     evm                 = 8569
#     files               = 5666
#     iam                 = 5787
#     logger              = 5009
#     monitoring          = 5008
#     notification        = 51552
#     pricing             = 5660
#     transaction_history = 5650
#     workers             = 5007
#   }
#
#   common_environment_variables = concat(
#     [
#       { name = "ENVIRONMENT", value = var.env_name },
#       { name = "BROKER_HOST", value = format(var.broker_host_template, var.env_name) },
#       { name = "S3_BUCKET_DIR", value = "DR-Sandbox" }
#     ],
#     [
#       for service, port in local.service_ports :
#       {
#         name  = upper(replace("${service}_SERVICE", "-", "_")),
#         value = "${replace(service, "_", "")}.${local.service_discovery_namespace}:${port}"
#       }
#     ]
#   )
#
#
#
#   default_health_check = {
#     command      = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
#     interval     = 60
#     timeout      = 7
#     retries      = 3
#     start_period = 60
#   }
#
#   services = {
#     account = {
#       cpu            = 256
#       memory         = 512
#       image_tag      = "account"
#       container_port = local.service_ports.account
#       desired_count  = 1
#       environment = concat(local.common_environment_variables, [
#         { name = "SERVICE_NAME", value = "account" },
#         { name = "S3_BUCKET", value = "dr-sandbox-amrs-files" },
#         { name = "REPORTS_S3_BUCKET", value = "ar-amrs-reports-exports" },
#         { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/account"},
#         { name = "DATABASE_URL", value = "${local.rds_connection_string}/account"},
#         { name = "PORT", value = tostring(local.service_ports.account) },
#         { name = "RABBITMQ_URL", value = format(local.rabbitmq_url, "account") },
#       ])
#       secrets = [
#         {
#           name      = "TWO_FACTOR_SECRET",
#           valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_TWO_FACTOR_SECRET-4q8Sys"
#         },
#       ]
#     },
#     amrs = {
#       cpu            = 256
#       memory         = 512
#       image_tag      = "amrs"
#       container_port = local.service_ports.amrs
#       desired_count  = 1
#       environment = concat(local.common_environment_variables, [
#         { name = "SERVICE_NAME", value = "amrs" },
#         { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/amrs"},
#         { name = "DATABASE_URL", value = "${local.rds_connection_string}/amrs"},
#         { name = "PORT", value = tostring(local.service_ports.amrs) },
#         { name = "RABBITMQ_URL", value = format(local.rabbitmq_url, "amrs") },
#         { name = "S3_BUCKET", value = "dr-sandbox-amrs-files" },
#         { name = "REPORTS_S3_BUCKET", value = "ar-amrs-reports-exports" },
#       ])
#       secrets = [
#         {
#           name = "AIRTABLE_KEY",
#           valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_AIRTABLE_KEY-niq1J8"
#         }
#       ]
#     },
#     auth = {
#       cpu            = 256
#       memory         = 512
#       container_port = local.service_ports.auth
#       desired_count  = 1
#       image_tag      = "auth"
#       environment = concat(local.common_environment_variables, [
#         { name = "SERVICE_NAME", value = "auth" },
#         { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/auth"},
#         { name = "DATABASE_URL", value = "${local.rds_connection_string}/auth"},
#         { name = "PORT", value = tostring(local.service_ports.auth) },
#       ])
#       secrets = [
#         {
#           name      = "ROOT_AR_TOKEN",
#           valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_ROOT_AR_TOKEN-jzvsbY"
#         },
#       ]
#       health_check  = local.default_health_check
#       port_mappings = [
#         {
#           name          = "auth-${local.service_ports.auth}-tcp"
#           containerPort = local.service_ports.auth
#           hostPort      = local.service_ports.auth
#           protocol      = "tcp"
#         },
#         {
#           name          = "auth-5000-tcp"
#           containerPort = 5000
#           hostPort      = 5000
#           protocol      = "tcp"
#         }
#       ]
#     },
#     blockchain = {
#       cpu            = 256
#       memory         = 512
#       container_port = local.service_ports.blockchain
#       image_tag      = "blockchain"
#       desired_count  = 1
#       environment = concat(local.common_environment_variables, [
#         { name = "SERVICE_NAME", value = "blockchain" },
#         { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/blockchain"},
#         { name = "DATABASE_URL", value = "${local.rds_connection_string}/blockchain"},
#         { name = "RABBITMQ_URL", value = format(local.rabbitmq_url, "blockchain") },
#         { name = "PORT", value = tostring(local.service_ports.blockchain) },
#       ])
#       secrets = [
#         {
#           name      = "BLOCKDAEMON_API_KEY",
#           valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_BLOCKDAEMON_API_KEY-JyOfp8"
#         },
#         {
#           name      = "ANKR_API_KEY",
#           valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_ANKR_API_KEY-d6ZLee"
#         },
#       ]
#       health_check  = local.default_health_check
#       port_mappings = [
#         {
#           name          = "blockchain-${local.service_ports.blockchain}-tcp"
#           containerPort = local.service_ports.blockchain
#           hostPort      = local.service_ports.blockchain
#           protocol      = "tcp"
#         }
#       ]
#     },
#     broker = {
#       cpu            = 256
#       memory         = 512
#       image_tag = "broker"
#       container_port = local.service_ports.broker
#       desired_count  = 1
#       environment = concat(local.common_environment_variables, [
#         { name = "SERVICE_NAME", value = "broker" },
#         { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/broker"},
#         { name = "PORT", value = tostring(local.service_ports.broker) }
#       ])
#       secrets = [
#         {
#           name      = "EXCHANGE_RATES_API_KEY",
#           valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_EXCHANGE_RATES_API_KEY-cod4g2"
#         },
#       ]
#       health_check = local.default_health_check
#     },
#     iam = {
#       cpu            = 256
#       memory         = 512
#       image_tag = "iam"
#       container_port = local.service_ports.iam
#       desired_count  = 1
#       environment = concat(local.common_environment_variables, [
#         { name = "SERVICE_NAME", value = "iam" },
#         { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/iam"},
#         { name = "ACCOUNT_SERVICE", value = "account.${var.env_name}.ar-service-ns:${local.service_ports.account}" },
#         { name = "PORT", value = tostring(local.service_ports.iam) },
#         { name = "CACHE_ENV", value = var.env_name },
#         { name = "REDIS_URL", value = "redis://default:@assetreality-cache.2bolip.ng.0001.euw3.cache.amazonaws.com:6379/2" },
#       ])
#       secrets = [
#         { name = "JWT_SECRET", valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_JWT_SECRET-k4cTdo" },
#       ]
#       health_check  = local.default_health_check
#       port_mappings = [
#         {
#           name          = "iam-${local.service_ports.iam}-tcp"
#           containerPort = local.service_ports.iam
#           hostPort      = local.service_ports.iam
#           protocol      = "tcp"
#         }
#       ]
#       log_configuration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = "asset-reality-iam-logs"
#           awslogs-region        = "${var.aws_region}"
#           awslogs-stream-prefix = "ecs-iam"
#         }
#       }
#     },
#     logger = {
#       cpu            = 256
#       memory         = 512
#       image_tag = "logger"
#       container_port = local.service_ports.logger
#       desired_count  = 1
#       environment = concat(local.common_environment_variables, [
#         { name = "SERVICE_NAME", value = "logger" },
#         { name = "ACCOUNT_SERVICE", value = "account.${var.env_name}.local:${local.service_ports.account}" },
#         { name = "DATABASE_URL", value = "${local.rds_connection_string}/logger" },
#         { name = "PORT", value = tostring(local.service_ports.logger) },
#         { name = "AUTH_SERVICE", value = "auth.${var.env_name}.ar-service-ns:${local.service_ports.auth}" },
#       ])
#       health_check  = local.default_health_check
#       port_mappings = [
#         {
#           name          = "logger-${local.service_ports.logger}-tcp"
#           containerPort = local.service_ports.logger
#           hostPort      = local.service_ports.logger
#           protocol      = "tcp"
#         }
#       ]
#       log_configuration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = "asset-reality-logger-logs"
#           awslogs-region        = "${var.aws_region}"
#           awslogs-stream-prefix = "ecs-logger"
#         }
#       }
#     }
#   }
#   services_json = jsonencode(local.services)
# }