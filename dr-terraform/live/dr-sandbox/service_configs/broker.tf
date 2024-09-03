# service_configs/broker.tf

locals {
  broker = {
    name           = "broker"
    cpu            = 1024
    memory         = 2048
    image_tag      = "3232abc7-broker"
    container_port = 5002
    desired_count  = 1

    environment = [
      { name = "SERVICE_NAME", value = "broker" },
      { name = "PORT", value = "5002" },

    ]

    secrets = [

    ]

    health_check = {
      command     = ["CMD-SHELL", "curl -sf http://localhost:5002/health || exit 1"]
      interval    = 60
      timeout     = 7
      retries     = 3
      startPeriod = 60
    }

    log_configuration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${env_name}-broker"
        awslogs-region        = aws_region
        awslogs-stream-prefix = "ecs"
        awslogs-create-group  = "true"

      }
    }

    port_mappings = [
      {
        containerPort = 5002
        hostPort      = 5002
        protocol      = "tcp"
      }
    ]
  }
}