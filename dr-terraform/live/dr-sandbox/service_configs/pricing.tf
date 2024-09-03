# service_configs/pricing.tf

locals {
  pricing = {
    name           = "pricing"
    cpu            = 512
    memory         = 1024
    image_tag      = "ce539766-pricing"  # This might need to be dynamically updated
    container_port = 5660
    desired_count  = 1  # Adjust as needed

    environment = [
      { name = "PORT", value = "5660" },
      { name = "SERVICE_NAME", value = "pricing" },
      { name = "ENVIRONMENT", value = env_name }
    ]

    secrets = [
      {
        name      = "SG_KEY"
        valueFrom = "arn:aws:secretsmanager:${aws_region}:609902089584:secret:SANDBOX_SG_KEY-hNZFSE"
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
        awslogs-group         = "AR/ecs/${env_name}/pricing-service"
        awslogs-create-group  = "true"
        awslogs-region        = aws_region
        awslogs-stream-prefix = "pricing-service"
      }
    }

    port_mappings = [
      {
        containerPort = 5660
        hostPort      = 5660
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