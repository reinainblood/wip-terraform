# vpc_id = "vpc-022a17dbda5db5471"
# # DocumentDB
# docdb_cluster_identifier  = "dr-sandbox-docdb"
# docdb_username            = "ar"
# docdb_password            = ""
# docdb_snapshot_identifier = "rds:assetreality-documentdb-cluster-2024-08-06-00-13"
# docdb_instance_count      = 1
# docdb_instance_class      = "db.t3.medium"
# docdb_vpc_security_group_ids = ["sg-0677a5c1306efde36"]
# docdb_subnet_group_name = "asset-reality"
#
# # RDS PostgreSQL
# rds_cluster_identifier          = "dr-sandbox-postgres"
# postgres_username               = "assetreality"
# postgres_password = ""  # Replace with a secure password
# rds_cluster_snapshot_identifier = "arn:aws:rds:eu-west-3:609902089584:cluster-snapshot:rds:assetreality-instance-sandbox-cluster-2024-08-06-05-06"
# rds_vpc_security_group_ids = ["sg-0e2536998fc61c1c8"]
# rds_subnet_group_name           = "asset-reality"
# rds_parameter_group_name        = "default:aurora-postgresql-14"
# rds_final_snapshot_identifier   = "dr-sandbox-postgres-final-snapshot"
#
#
# # RabbitMQ
# # mq_username  = "ar"
# # mq_password  = "xlDuBjyWpAapPvrP"
# environment        = "dr-sandbox"
# users_file         = "rabbitmq_users.json"
# broker_name        = "dr-sandbox-assetreality-broker"
# host_instance_type = "mq.t3.micro"
# rabbitmq_admin_password = "xlDuBjyWpAapPvrP"
#
# # ECS task def env vars
# # docdb_connection_string = local.docdb_connection_string
# # rds_connection_string = local.rds_connection_string
#
#
# common_environment_variables = [
#   { name = "ENVIRONMENT", value = "dr-sandbox" },
#   { name = "IAM_SERVICE", value = "iam.dr-sandbox.local:5787" },
#   { name = "NOTIFICATION_SERVICE", value = "notification.dr-sandbox.local:51552" },
#   { name = "BLOCKCHAIN_SERVICE", value : "blockchain.dr-sandbox.local:5777" },
#   { name = "AUTH_SERVICE", value = "auth.dr-sandbox.local:5001" },
#   { name = "PRICING_SERVICE", value = "pricing.dr-sandbox.local:5660" },
#   { name = "WORKERS_SERVICE", value = "workers.dr-sandbox.local:5007" },
#   { name = "EVM_SERVICE", value = "evm.dr-sandbox.local:8569" },
#   { name = "FILES_SERVICE", value = "files.dr-sandbox.local:5666" },
#   { name = "S3_BUCKET", value = "dr-sandbox-amrs-files" },
#   { name = "ACCOUNT_SERVICE", value = "account.dr-sandbox.local:5999" },
#   { name = "MONITORING_SERVICE", value = "monitoring.dr-sandbox.local:5008" },
#   { name = "BROKER_HOST", value = "https://dr-sandbox.broker.assetreality.org" },
#   { name = "CUSTODIAN_SERVICE", value = "custodian.sandbox.ar-service-ns:8565" },
#   { name = "S3_BUCKET_DIR", value = "Sandbox" },
#   { name = "LOGGER_SERVICE", value = "logger.dr-sandbox.local:5009" },
#   { name = "TRANSACTION_HISTORY_SERVICE", value = "transactionhistory.dr-sandbox.local:5650" }
# ]
# # ECS cluster and task definitions
# aws_region                  = "eu-west-3"
# cluster_name                = "dr-sandbox-asset-reality-cluster"
# ecs_task_execution_role_arn = "arn:aws:iam::609902089584:role/assetreality-ecs-tasks-role-sandbox"
# ecs_task_role_arn           = "arn:aws:iam::609902089584:role/assetreality-ecs-tasks-role-sandbox"
# ecr_repository_url          = "609902089584.dkr.ecr.eu-west-3.amazonaws.com/asset-reality-repository"
# subnet_ids = ["subnet-0599836d34968e0ce", "subnet-01aebe9126bc94aab", "subnet-0e4d8e96a4724bf91"]
# ecs_tasks_security_group_id = "sg-05d7a0936e746f74f"  # ECS_broker-sandbox is currently for all services
# service_discovery_namespace = "dr-sandbox.local"
# services = {
#   account = {
#     cpu            = 256
#     memory         = 512
#     image_tag      = "account"
#     container_port = 5999
#     desired_count  = 1
#     environment = concat(var.common_environment_variables, [
#       { name = "SERVICE_NAME", value = "account" },
#       { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/account"},
#       { name = "DATABASE_URL", value = "${local.rds_connection_string}/account"},
#       { name = "PORT", value = "5999" },
#       {
#         name  = "RABBITMQ_URL",
#         value = "amqps://account:LFcMC4y1e6ie69gA@b-77653e78-0902-4cb7-a05d-ec06fa7b84da.mq.eu-west-3.amazonaws.com:5671"
#       },
#     ])
#     secrets = [
#       {
#         name      = "TWO_FACTOR_SECRET",
#         valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_TWO_FACTOR_SECRET-4q8Sys"
#       },
#     ]
#   },
#   amrs = {
#     cpu            = 256
#     memory         = 512
#     image_tag      = "amrs"
#     container_port = 5000
#     desired_count  = 1
#     environment = concat(var.common_environment_variables, [
#       { name = "SERVICE_NAME", value = "amrs" },
#       { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/amrs"},
#       { name = "DATABASE_URL", value = "${local.rds_connection_string}/amrs"},
#       { name = "PORT", value = "5999" },
#       {
#         name  = "RABBITMQ_URL",
#         value = "amqps://amrs:LFcMC4y1e6ie69gA@b-77653e78-0902-4cb7-a05d-ec06fa7b84da.mq.eu-west-3.amazonaws.com:5671"
#       },
#       { name = "S3_BUCKET", value = "dr-sandbox-amrs-files" },
#       { name = "SERVICE_NAME", value = "amrs" },
#       { name = "PORT", value = "5003" },
#       { name = "S3_BUCKET_DIR", value = "DR-Sandbox" },
#       { name = "REPORTS_S3_BUCKET", value = "ar-amrs-reports-exports" },
#     ])
#     secrets = [
#       {
#         name = "AIRTABLE_KEY",
#         valueFrom : "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_AIRTABLE_KEY-niq1J8"
#       }
#     ]
#   },
#   auth = {
#     cpu           = 256
#     memory        = 512
#     container_port = 5001  # Primary port, but we'll define both in port_mappings
#     desired_count = 1
#     image_tag     = "auth"
#     environment = concat(
#       var.common_environment_variables,
#       [
#         { name = "SERVICE_NAME", value = "auth" },
#         { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/auth}"},
#         { name = "DATABASE_URL", value = "${local.rds_connection_string}/auth"},
#         { name = "PORT", value = "5000" },
#       ]
#     )
#     secrets = [
#       {
#         name      = "ROOT_AR_TOKEN",
#         valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_ROOT_AR_TOKEN-jzvsbY"
#       },
#     ]
#     health_check = {
#       command = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
#       interval     = 60
#       timeout      = 7
#       retries      = 3
#       start_period = 60
#     }
#     port_mappings = [
#       {
#         name          = "auth-5001-tcp"
#         containerPort = 5001
#         hostPort      = 5001
#         protocol      = "tcp"
#       },
#       {
#         name          = "auth-5000-tcp"
#         containerPort = 5000
#         hostPort      = 5000
#         protocol      = "tcp"
#       }
#     ]
#   },
#   blockchain = {
#     cpu            = 256
#     memory         = 512
#     container_port = 5777
#     image_tag      = "blockchain"
#     desired_count  = 1
#     environment = concat(
#       var.common_environment_variables,
#       [
#         { name = "SERVICE_NAME", value = "blockchain" },
#         { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/blockchain}"},
#         { name = "DATABASE_URL", value = "${local.rds_connection_string}/blockchain"},
#         {
#           name  = "RABBITMQ_URL",
#           value = "mqps://blockchain:LFcMC4y1e6ie69gA@b-77653e78-0902-4cb7-a05d-ec06fa7b84da.mq.eu-west-3.amazonaws.com:5671"
#         },
#         {
#           name  = "DATABASE_URL",
#           value = "postgres://blockchain:amrifTHCn5g9IYNv@assetreality-instance-sandbox-cluster.cluster-czlgla4ntngu.eu-west-3.rds.amazonaws.com:5432/blockchain"
#         },
#         { name = "PORT", value = "5777" },
#       ]
#     )
#     secrets = [
#       {
#         name      = "BLOCKDAEMON_API_KEY",
#         valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_BLOCKDAEMON_API_KEY-JyOfp8"
#       },
#       {
#         name      = "ANKR_API_KEY",
#         valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_ANKR_API_KEY-d6ZLee"
#       },
#     ]
#     health_check = {
#       command = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
#       interval     = 60
#       timeout      = 7
#       retries      = 3
#       start_period = 60
#     }
#     port_mappings = [
#       {
#         name          = "blockchain-5777-tcp"
#         containerPort = 5777
#         hostPort      = 5777
#         protocol      = "tcp"
#       }
#     ]
#   },
#   broker = {
#     cpu            = 256
#     memory         = 512
#     container_port = 5002
#     desired_count  = 1
#     environment = [
#       { name = "SERVICE_NAME", value = "broker" },
#       { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/broker}"},
#       { name = "PORT", value = "5002" }
#     ]
#     secrets = [
#       {
#         name      = "EXCHANGE_RATES_API_KEY",
#         valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_EXCHANGE_RATES_API_KEY-cod4g2"
#       },
#     ]
#     health_check = {
#       command = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
#       interval     = 60
#       timeout      = 7
#       retries      = 3
#       start_period = 60
#     }
#   }
#   chain-arbitrum-monitor = {
#     cpu            = 256
#     memory         = 512
#     image_tag      = "chain-arbitrum-monitor"
#     container_port = 5004
#     desired_count  = 1
#     environment = concat(var.common_environment_variables,
#       [
#         { name = "SERVICE_NAME", value = "chain-arbitrum-monitor" },
#         { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/chain-arbitrum-monitor}"},
#         { name = "LISTENER_SERVICE", value = "listener-service.dr-sandbox.local:1616" }
#       ])
#     secrets = []
#   },
#   chain-bch-monitor = {
#     cpu            = 256
#     memory         = 512
#     container_port = 4004
#     desired_count  = 1
#     environment = concat(
#       var.common_environment_variables,
#       [
#         { name = "PORT", value = "4004" },
#         { name = "LISTENER_SERVICE", value = "listener-service.dr-sandbox.local:1616" },
#       ]
#     )
#     secrets = []
#     health_check = {
#       command = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
#       interval     = 60
#       timeout      = 7
#       retries      = 3
#       start_period = 60
#     }
#     port_mappings = [
#       {
#         containerPort = 4004
#         hostPort      = 4004
#         protocol      = "tcp"
#       }
#     ]
#     container_name = "bchMonitor"
#   },
#   chain-btc-monitor = {
#     cpu            = 256
#     memory         = 512
#     container_port = 1818
#     desired_count  = 1
#     environment = concat(
#       var.common_environment_variables,
#       [
#         { name = "PORT", value = "1818" },
#         { name = "LISTENER_SERVICE", value = "listener-service.dr-sandbox.local:1616" },
#       ]
#     )
#     secrets = []
#     health_check = {
#       command = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
#       interval     = 60
#       timeout      = 7
#       retries      = 3
#       start_period = 60
#     }
#     port_mappings = [
#       {
#         containerPort = 1818
#         hostPort      = 1818
#         protocol      = "tcp"
#       }
#     ]
#     container_name = "btcMonitor"
#   },
#   chain-doge-monitor = {
#     cpu            = 256
#     memory         = 512
#     container_port = 4006
#     desired_count  = 1
#     environment = concat(
#       var.common_environment_variables,
#       [
#         { name = "PORT", value = "4006" },
#         { name = "LISTENER_SERVICE", value = "listener-service.dr-sandbox.local:1616" },
#       ]
#     )
#     secrets = []
#     health_check = {
#       command = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
#       interval     = 60
#       timeout      = 7
#       retries      = 3
#       start_period = 60
#     }
#     port_mappings = [
#       {
#         containerPort = 4006
#         hostPort      = 4006
#         protocol      = "tcp"
#       }
#     ]
#     container_name = "dogeMonitor"
#   },
#   "chain-eth-monitor" = {
#     cpu            = 256
#     memory         = 512
#     image_tag      = "latest-chain-eth-monitor"
#     container_port = 5008
#     desired_count  = 1
#     environment = [
#       { name = "SERVICE_NAME", value = "chain-eth-monitor" },
#       { name = "ENVIRONMENT", value = "dr-sandbox" }
#     ]
#     secrets = []
#   },
#   "chain-ltc-monitor" = {
#     cpu            = 256
#     memory         = 512
#     image_tag      = "latest-chain-ltc-monitor"
#     container_port = 5009
#     desired_count  = 1
#     environment = [
#       { name = "SERVICE_NAME", value = "chain-ltc-monitor" },
#       { name = "ENVIRONMENT", value = "dr-sandbox" }
#     ]
#     secrets = []
#   },
#   "chain-matic-monitor" = {
#     cpu            = 256
#     memory         = 512
#     image_tag      = "latest-chain-matic-monitor"
#     container_port = 5010
#     desired_count  = 1
#     environment = [
#       { name = "SERVICE_NAME", value = "chain-matic-monitor" },
#       { name = "ENVIRONMENT", value = "dr-sandbox" }
#     ]
#     secrets = []
#   },
#   "chain-xrp-monitor" = {
#     cpu            = 256
#     memory         = 512
#     image_tag      = "latest-chain-xrp-monitor"
#     container_port = 5011
#     desired_count  = 1
#     environment = [
#       { name = "SERVICE_NAME", value = "chain-xrp-monitor" },
#       { name = "ENVIRONMENT", value = "dr-sandbox" }
#     ]
#     secrets = []
#   },
#   iam = {
#     cpu            = 256
#     memory         = 512
#     container_port = 5787
#     desired_count  = 1
#     environment = concat(
#       var.common_environment_variables,
#       [
#         { name = "SERVICE_NAME", value = "iam" },
#         { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/aim}"},
#         { name = "ACCOUNT_SERVICE", value = "account.sandbox.ar-service-ns:5999" },
#         { name = "PORT", value = "5787" },
#         { name = "ENVIRONMENT", value = "sandbox" },
#         { name = "CACHE_ENV", value = "sandbox" },
#         { name = "REDIS_URL", value = "redis://default:@assetreality-cache.2bolip.ng.0001.euw3.cache.amazonaws.com:6379/2" },
#       ]
#     )
#     secrets = [
#       { name = "JWT_SECRET", valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_JWT_SECRET-k4cTdo" },
#     ]
#     health_check = {
#       command     = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
#       interval    = 60
#       timeout     = 7
#       retries     = 3
#       start_period = 60
#     }
#     port_mappings = [
#       {
#         name           = "iam-5787-tcp"
#         containerPort  = 5787
#         hostPort       = 5787
#         protocol       = "tcp"
#       }
#     ]
#     log_configuration = {
#       logDriver = "awslogs"
#       options = {
#         awslogs-group         = "asset-reality-iam-logs"
#         awslogs-region        = "eu-west-3"
#         awslogs-stream-prefix = "ecs-iam"
#       }
#     }
#   },
#   logger = {
#     cpu            = 256
#     memory         = 512
#     container_port = 5009
#     desired_count  = 1
#     environment = [
#       { name = "SERVICE_NAME", value = "logger" },
#       { name = "ACCOUNT_SERVICE", value = "account.dr-sandbox.local:5999" },
#       { name = "DATABASE_URL", value = "postgres://logger:xHvJ8NkOQP5JI30i@assetreality-instance-sandbox-cluster.cluster-czlgla4ntngu.eu-west-3.rds.amazonaws.com:5432/logger" },
#       { name = "PORT", value = "5009" },
#       { name = "AUTH_SERVICE", value = "auth.sandbox.ar-service-ns:5001" },
#       { name = "ENVIRONMENT", value = "sandbox" },
#     ]
#     secrets = []
#     health_check = {
#       command     = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
#       interval    = 60
#       timeout     = 7
#       retries     = 3
#       start_period = 60
#     }
#     port_mappings = [
#       {
#         name           = "logger-5009-tcp"
#         containerPort  = 5009
#         hostPort       = 5009
#         protocol       = "tcp"
#       }
#     ]
#     log_configuration = {
#       logDriver = "awslogs"
#       options = {
#         awslogs-group         = "asset-reality-logger-logs"
#         awslogs-region        = "eu-west-3"
#         awslogs-stream-prefix = "ecs-logger"
#       }
#     }
#   }
#   logger = {
#     cpu            = 256
#     memory         = 512
#     image_tag      = "latest-logger"
#     container_port = 5013
#     desired_count  = 1
#     environment = [
#       { name = "SERVICE_NAME", value = "logger" },
#       { name = "DOC_DB_URL", value = "${local.docdb_connection_string}/logger}"},
#       { name = "ENVIRONMENT", value = "dr-sandbox" }
#     ]
#     secrets = []
#   }
# }