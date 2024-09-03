vpc_id = "vpc-064688c92fda38609"
env_name = "dr-sandbox"
account_id = 609902089584
ecr_repository_name = "asset-reality-repository"

# s3 copy vars
source_region = "eu-west-3"
destination_region = "eu-west-1"
# DocumentDB
create_docdb = false
docdb_cluster_identifier  = "dr-sandbox-docdb"
docdb_username            = "ar"
docdb_password            = ""
docdb_snapshot_identifier = "rds:assetreality-documentdb-cluster-2024-08-06-00-13"
docdb_instance_class      = "db.t3.medium"
docdb_vpc_security_group_ids = ["sg-0677a5c1306efde36"]
docdb_subnet_group_name = "asset-reality"
docdb_secret_name = "DR-SANDBOX-DOCDB-BASE-URL"

# RDS PostgreSQL
rds_cluster_identifier          = "${var.env_name}-postgres"
postgres_username               = "assetreality"
postgres_password = ""  # Replace with a secure password
rds_cluster_snapshot_identifier = "arn:aws:rds:eu-west-3:609902089584:cluster-snapshot:rds:assetreality-instance-sandbox-cluster-2024-08-06-05-06"
rds_vpc_security_group_ids = ["sg-0e2536998fc61c1c8"]
rds_subnet_group_name           = "asset-reality"
rds_parameter_group_name        = "default:aurora-postgresql-14"
rds_final_snapshot_identifier   = "dr-sandbox-postgres-final-snapshot"


# RabbitMQ
# mq_username  = "ar"
# mq_password  = "xlDuBjyWpAapPvrP"
environment        = "dr-sandbox"
users_file         = "rabbitmq_users.json"
broker_name        = "dr-sandbox-assetreality-broker"
host_instance_type = "mq.t3.micro"
rabbitmq_admin_password = "xlDuBjyWpAapPvrP"

# ECS task def env vars

rds_secret_arn = "dr-sandbox-postgres-ecs-users-cred"


# ECS cluster and task definitions
aws_region                  = "eu-west-3"
cluster_name                = "dr-sandbox-asset-reality-cluster"
ecs_task_execution_role_arn = "arn:aws:iam::609902089584:role/assetreality-ecs-tasks-role-sandbox"
ecs_task_role_arn           = "arn:aws:iam::609902089584:role/assetreality-ecs-tasks-role-sandbox"
ecr_repository_url          = "609902089584.dkr.ecr.eu-west-3.amazonaws.com/asset-reality-repository"
subnet_ids = ["subnet-038ee155e25417a44", "subnet-0cffc8b969d03f7c9", "subnet-03f4b2d9f14ba6eea"]
public_subnet_ids = ["subnet-038ee155e25417a44", "subnet-0cffc8b969d03f7c9", "subnet-03f4b2d9f14ba6eea"]
private_subnet_ids = ["subnet-0599836d34968e0ce", "subnet-01aebe9126bc94aab", "subnet-0e4d8e96a4724bf91"]
ecs_tasks_security_group_id = "sg-05d7a0936e746f74f"  # ECS_broker-sandbox is currently for all services
#temporariky hardcoding this for local testing only
docdb_connection_string = "mongodb://ar:VMzLsN7PiT3EcR4x@dr-sandbox-docdb.cluster-czlgla4ntngu.eu-west-3.docdb.amazonaws.com"
rds_connection_string = "postgres://ecs_user:gdqjcZUGVevYu48d@sandbox-dr-postgres.cluster-czlgla4ntngu.eu-west-3.rds.amazonaws.com"
rabbitmq_url = "amqps://ar:xlDuBjyWpAapPvrP@b-c4c9f448-70a3-4813-927c-b6abae9d48ef.mq.eu-west-3.amazonaws.com:5671"
temp_redis_connection_string = "redis://default:@dr-sandbox-redis-2bolip.serverless.euw3.cache.amazonaws.com:6379"

create_alb = ["auth", "broker", "governance"]