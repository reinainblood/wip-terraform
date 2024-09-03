# service_configs/files.tf

locals {
  files = {
    name           = "files"
    cpu            = 512
    memory         = 1024
    image_tag      = "ce539766-files"  # This might need to be dynamically updated
    container_port = 5666
    desired_count  = 1  # Adjust as needed
    essential = true
    environment = [
      { name = "SERVICE_NAME", value = "files" },
      { name = "FILE_PREVIEW_SERVICE_URL", value = "pdf-converter.${env_name}.local:3000" },
      { name = "PORT", value = "5666" },
      { name = "S3_REGION", value = aws_region },
    ]

    secrets = [
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
        awslogs-group         = "AR/ecs/${env_name}/files-service"
        awslogs-create-group  = "true"
        awslogs-region        = aws_region
        awslogs-stream-prefix = "files-service"
      }
    }

    port_mappings = [
      {
        containerPort = 5666
        hostPort      = 5666
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