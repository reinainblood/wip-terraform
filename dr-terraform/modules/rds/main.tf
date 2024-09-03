resource "aws_rds_cluster" "postgres" {
  cluster_identifier = var.rds_cluster_identifier
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"
  engine_version     = "14.9"
  database_name      = "assetreality"
  master_username    = var.master_username
  master_password    = var.master_password
  storage_encrypted  = true
  skip_final_snapshot = true
  apply_immediately = true
  db_subnet_group_name = var.db_subnet_group_name
  snapshot_identifier = var.rds_cluster_snapshot_identifier
  vpc_security_group_ids = var.rds_vpc_security_group_ids
  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}

resource "aws_rds_cluster_instance" "postgres_instance" {
  cluster_identifier = aws_rds_cluster.postgres.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.postgres.engine
  engine_version     = aws_rds_cluster.postgres.engine_version
}

# Local variables for RDS configuration
locals {
  rds_master_username = var.master_username
  rds_master_password = var.master_password
  rds_cluster_endpoint = aws_rds_cluster.postgres.endpoint

  # Construct the full connection string
  rds_connection_string = "postgres://${local.rds_master_username}:${local.rds_master_password}@${local.rds_cluster_endpoint}:5432"
}

# Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "rds_connection_string" {
  name = "${var.env_name}-rds-connection-string"
  description = "postgres connection string for dr-sandbox environment"
}

# Store the connection string in the secret
resource "aws_secretsmanager_secret_version" "rds_connection_string" {
  secret_id     = aws_secretsmanager_secret.rds_connection_string.id
  secret_string = local.rds_connection_string
}