resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "docdb"
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true

  snapshot_identifier     = var.snapshot_identifier

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name

  lifecycle {
    ignore_changes = [
      snapshot_identifier,
      master_username,
      master_password,
    ]
  }
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "${var.cluster_identifier}-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = var.instance_class
}

# Local variables for DocDB configuration
locals {
  docdb_master_username = var.master_username
  docdb_master_password = var.master_password
  docdb_cluster_endpoint = aws_docdb_cluster.docdb.endpoint

  # Construct the full connection string
  docdb_connection_string = "mongodb://${local.docdb_master_username}:${local.docdb_master_password}@${local.docdb_cluster_endpoint}:27017"
}

# Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "docdb_connection_string" {
  name = "dr-sandbox-docdb-connection-string"
  description = "DocDB connection string for dr-sandbox environment"
}

# Store the connection string in the secret
resource "aws_secretsmanager_secret_version" "docdb_connection_string" {
  secret_id     = aws_secretsmanager_secret.docdb_connection_string.id
  secret_string = local.docdb_connection_string
}