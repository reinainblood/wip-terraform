locals {


  monitoring = {
    name           = "monitoring"
    cpu            = 256
    memory         = 512
    image_tag = "10adb453-monitoring"  # This might need to be dynamically updated
    container_port = 5008
    desired_count = 1  # Adjust as needed

    environment = [
      { name = "SERVICE_NAME", value = "monitoring" },
      { name = "PORT", value = "5008" },
      { name = "EVM_SERVICE", value = "evm.${env_name}.local:8569" },
      { name = "ENVIRONMENT", value = env_name },
      { name = "LOGGER_SERVICE", value = "logger.${env_name}.local:5009" },
      { name = "AMRS_SERVICE", value = "amrs.${env_name}.local:5003" },
      { name = "NOTIFICATION_SERVICE", value = "notification.${env_name}.local:51552" }
    ]

    secrets = [
    ]

    health_check = {
      command = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
      interval    = 60
      timeout     = 7
      retries     = 3
      startPeriod = 60
    }

    log_configuration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "asset-reality-monitoring-logs"
        awslogs-region        = aws_region
        awslogs-stream-prefix = "ecs-monitoring"
      }
    }

    port_mappings = [
      {
        containerPort = 5008
        hostPort      = 5008
        protocol      = "tcp"
      }
    ]

    # Additional task definition settings
    requires_compatibilities = ["FARGATE"]
    network_mode       = "awsvpc"
    task_role_arn      = var.ecs_task_role_arn
    execution_role_arn = var.ecs_task_execution_role_arn
  }
}

