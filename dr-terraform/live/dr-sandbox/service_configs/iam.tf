# service_configs/iam.tf

locals {
  iam = {
    name           = "iam"
    cpu            = 512
    memory         = 1024
    image_tag      = "ce539766-iam"  # This might need to be dynamically updated
    container_port = 5787
    desired_count  = 1  # Adjust as needed
    essential = true
    environment = [
      { name = "SERVICE_NAME", value = "iam" },
      { name = "PORT", value = "5787" },
    ]

    secrets = [
      {
        name      = "JWT_SECRET"
        valueFrom = "arn:aws:secretsmanager:${aws_region}:609902089584:secret:${upper(env_name)}_JWT_SECRET-k4cTdo"
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
        awslogs-group         = "AR/ecs/${env_name}/iam-service"
        awslogs-create-group  = "true"
        awslogs-region        = aws_region
        awslogs-stream-prefix = "iam-service"
      }
    }

    port_mappings = [
      {
        containerPort = 5787
        hostPort      = 5787
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