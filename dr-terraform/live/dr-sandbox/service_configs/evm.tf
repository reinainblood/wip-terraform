# service_configs/evm.tf

locals {
  evm = {
    name           = "evm"
    cpu            = 512
    memory         = 1024
    image_tag      = "c274bb68-evm"
    container_port = 8569
    desired_count  = 1  # Adjust as needed

    environment = [
      { name = "SERVICE_NAME", value = "evm" },
      { name = "ICON_SERVICE_URL", value = "https://xk8s6gfm71.execute-api.eu-west-2.amazonaws.com/" },
      { name = "PORT", value = "8569" },

    ]

    secrets = [
      {
        name      = "ALCHEMY_API_KEY"
        valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_ALCHEMY_API_KEY-RYhhaQ"
      },
      {
        name      = "ANKR_API_KEY"
        valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_ANKR_API_KEY-d6ZLee"
      },
      {
        name      = "BLOCKDAEMON_API_KEY"
        valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_BLOCKDAEMON_API_KEY-JyOfp8"
      },
      {
        name      = "NOWNODES_API_KEY"
        valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_NOWNODES_API_KEY-MQ3OWI"
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
        awslogs-group         = "AR/ecs/${env_name}/evm-service"
        awslogs-create-group  = "true"
        awslogs-region        = aws_region
        awslogs-stream-prefix = "evm-service"
      }
    }

    port_mappings = [
      {
        containerPort = 8569
        hostPort      = 8569
        protocol      = "tcp"
      }
    ]

    # Additional task definition settings
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
  }
}