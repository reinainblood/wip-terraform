

locals {
  users_data = jsondecode(file("${var.users_file}"))
  users      = { for user in local.users_data.users : user.username => user }
}

data "aws_secretsmanager_secret" "user_secrets" {
  for_each = local.users
  name     = "assetreality-${var.service}-${each.key}-password"
}

data "aws_secretsmanager_secret_version" "user_secret_versions" {
  for_each  = data.aws_secretsmanager_secret.user_secrets
  secret_id = each.value.id
}

resource "aws_mq_broker" "rabbitmq" {
  broker_name = var.broker_name

  engine_type         = "RabbitMQ"
  engine_version      = "3.13"
  host_instance_type  = "mq.t3.micro"
  publicly_accessible = true
  auto_minor_version_upgrade = true

  user {
    username = "ar"
    password = var.rabbitmq_admin_password
    groups   = ["admin"]
  }

  # Annoyingly, AWS provider does not support adding multiple users like this, but i will leave this nice clean
  # block here for the future
#   dynamic "user" {
#     for_each = local.users
#     content {
#       username = user.key
#       password = data.aws_secretsmanager_secret_version.user_secret_versions[user.key].secret_string
#       groups   = user.value.groups
#     }
#   }
}
