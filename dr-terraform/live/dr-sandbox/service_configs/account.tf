locals {
  account = {
    name           = "account"
    cpu            = 512
    memory         = 1024
    image_tag      = "ce539766-account"
    container_port = 5999
    desired_count  = 1

    environment = [
      { name = "SERVICE_NAME", value = "account"},
      { name = "PORT", value = "5999" },
    ]

    secrets = [
      {
        name      = "TWO_FACTOR_SECRET"
        valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_TWO_FACTOR_SECRET-4q8Sys"
      },
    ]

    health_check = {
      command     = ["CMD-SHELL", "curl -sf http://localhost:5999/health || exit 1"]
      interval    = 60
      timeout     = 7
      retries     = 3
      startPeriod = 60
    }

    log_configuration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${env_name}-account"
        awslogs-region        = aws_region
        awslogs-stream-prefix = "ecs"
        awslogs-create-group  = "true"

      }
    }

    port_mappings = [
      {
        containerPort = 5999
        hostPort      = 5999
        protocol      = "tcp"
      }
    ]
  }
}