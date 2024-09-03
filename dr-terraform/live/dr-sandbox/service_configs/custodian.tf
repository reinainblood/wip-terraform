# service_configs/custodian.tf

locals {
  custodian = {
    name           = "custodian"
    cpu            = 512
    memory         = 1024
    image_tag      = "3232abc7-custodian"
    container_port = 8565
    desired_count  = 1  # Adjust as needed, not specified in the JSON

    environment = [
      { name = "PORT", value = "8565" },
      { name = "SERVICE_NAME", value = "custodian" },
    ]

    secrets = [
      {
        name      = "FIREBLOCKS_API_KEY"
        valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_FIREBLOCKS_API_KEY-uPaXsf"
      },
      {
        name      = "FIREBLOCKS_API_SECRET"
        valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_FIREBLOCKS_API_SECRET-PQVJFB"
      },
      {
        name      = "PRIVATE_KEY"
        valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:${service_name}_PRIVATE_KEY-c6o8lW"
      },

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
        awslogs-group         = "AR/ecs/assetreality-dr-sandbox/${service_name}-service"
        awslogs-create-group  = "true"
        awslogs-region        = "eu-west-3"
        awslogs-stream-prefix = "${service_name}-service"
      }
    }

    port_mappings = [
      {
        containerPort = 8565
        hostPort      = 8565
        protocol      = "tcp"
      }
    ]

    # Additional task definition settings
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
  }
}