# service_configs/notification.tf

locals {
  notification = {
    name           = "notification"
    cpu            = 512
    memory         = 1024
    image_tag      = "ce539766-notification"  # This might need to be dynamically updated
    container_port = 51552
    desired_count  = 1  # Adjust as needed

    environment = [
      { name = "PORT", value = "51552" },
      { name = "SERVICE_NAME", value = "notification" },
      { name = "ENVIRONMENT", value = env_name }
    ]

    secrets = [
      {
        name      = "SG_KEY"
        valueFrom = "arn:aws:secretsmanager:${aws_region}:609902089584:secret:${upper(env_name)}_SG_KEY-hNZFSE"
      }
    ]

    health_check = {
      command     = ["CMD-SHELL", "curl -sf ECS_CONTAINER_METADATA_URI | jq '.Health.status' || exit 1"]
      interval    = 60
      timeout     = 60
      retries     = 3
      startPeriod = 0
    }

    log_configuration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "AR/ecs/${env_name}/notification-service"
        awslogs-create-group  = "true"
        awslogs-region        = aws_region
        awslogs-stream-prefix = "notification-service"
      }
    }

    port_mappings = [
      {
        containerPort = 51552
        hostPort      = 51552
        protocol      = "tcp"
      }
    ]

    # Additional task definition settings
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    task_role_arn            = var.ecs_task_role_arn
    execution_role_arn       = var.ecs_task_execution_role_arn
  }
}