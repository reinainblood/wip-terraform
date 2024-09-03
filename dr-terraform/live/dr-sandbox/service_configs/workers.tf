# service_configs/workers.tf

locals {
  workers = {
    name           = "workers"
    cpu            = 512
    memory         = 1024
    image_tag      = "ce539766-workers"  # This might need to be dynamically updated
    container_port = 5007
    desired_count  = 1  # Adjust as needed

    environment = [
      { name = "SERVICE_NAME", value = "workers" },
      { name = "PORT", value = "5007" },
    ]

    secrets = [
      {
        name      = "EXCHANGE_RATES_API_KEY"
        valueFrom = "arn:aws:secretsmanager:${aws_region}:609902089584:secret:SANDBOX_EXCHANGE_RATES_API_KEY-cod4g2"
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
        awslogs-group         = "AR/ecs/${env_name}/workers-service"
        awslogs-create-group  = "true"
        awslogs-region        = aws_region
        awslogs-stream-prefix = "workers-service"
      }
    }

    port_mappings = [
      {
        containerPort = 5007
        hostPort      = 5007
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