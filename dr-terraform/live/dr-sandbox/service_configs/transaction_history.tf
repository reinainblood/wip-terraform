locals {


  transactionhistory = {
    name           = "transactionhistory"
    cpu            = 256
    memory         = 512
    image_tag = "e4056756-transaction-history"  # This might need to be dynamically updated
    container_port = 5650
    desired_count = 1  # Adjust as needed

    environment = [
      { name = "SERVICE_NAME", value = "transactionhistory" },
      { name = "PORT", value = "5650" },
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
        awslogs-group         = "asset-reality-transactionhistory-logs"
        awslogs-region        = aws_region
        awslogs-stream-prefix = "ecs-transactionhistory"
        awslogs-create-group  = "true"
      }
    }

    port_mappings = [
      {
        containerPort = 5650
        hostPort      = 5650
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

