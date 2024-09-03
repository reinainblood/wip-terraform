# service_configs/_services.tf

locals {
  default_health_check = {
    command      = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
    interval     = 60
    timeout      = 7
    retries      = 3
    start_period = 60
  }

  # Common environment variables
  common_environment_variables = [
    { name = "ENVIRONMENT", value = "${env_name}" },
    { name = "BROKER_HOST", value = format("${broker_host_template}", "${env_name}") },
    { name = "S3_BUCKET_DIR", value = "DR-Sandbox" },
    { name = "S3_BUCKET", value = "${s3_bucket_name}" },
    { name = "FILES_BUCKET", value = "${files_bucket}"},
    { name = "REPORTS_S3_BUCKET", value = "${reports_s3_bucket}"},
    { name = "CACHE_ENV", value = "${env_name}"},
    { name = "ACCOUNT_SERVICE", value = "account.${env_name}.local:5999" },
    { name = "LOGGER_SERVICE", value = "logger.${env_name}.local:5009" },
    { name = "AMRS_SERVICE", value = "amrs.${env_name}.local:5003" },
    { name = "AUTH_SERVICE", value = "auth.${env_name}.local:5001" },
    { name = "BLOCKCHAIN_SERVICE", value = "blockchain.${env_name}.local:5777" },
    { name = "CUSTODIAN_SERVICE", value = "custodian.${env_name}.local:8565" },
    { name = "EVM_SERVICE", value = "evm.${env_name}.local:8569" },
    { name = "FILES_SERVICE", value = "files.${env_name}.local:5666" },
    { name = "IAM_SERVICE", value = "iam.${env_name}.local:5787" },
    { name = "LOGGER_SERVICE", value = "logger.${env_name}.local:5009" },
    { name = "MONITORING_SERVICE", value = "monitoring.${env_name}.local:5008" },
    { name = "NOTIFICATION_SERVICE", value = "notification.${env_name}.local:51552" },
    { name = "PRICING_SERVICE", value = "pricing.${env_name}.local:5660" },
    { name = "TRANSACTION_HISTORY_SERVICE", value = "transactionhistory.${env_name}.local:5650" },
    { name = "WORKERS_SERVICE", value = "workers.${env_name}.local:5007" },
  ]

  common_secrets = [
    {
      name      = "DOC_DB_URL"
      valueFrom = "${docdb_connection_string}"
    },
    {
      name      = "DATABASE_URL"
      valueFrom = "${rds_connection_string}"
    },
    {
      name      = "RABBITMQ_URL"
      valueFrom = "${rabbitmq_url}"
    },
    {
      name  = "REDIS_URL"
      value = "${temp_redis_connection_string}"
    }
  ]
}