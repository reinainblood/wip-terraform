# service_configs/auth.tf

locals {
  auth = {
    name           = "auth"
    cpu            = 512
    memory         = 1024
    image_tag      = "ce539766-auth"
    container_port = 80   # The load balancer is configured for port 80
    desired_count  = 1
    essential = true
    environment = [
      { name = "SERVICE_NAME", value = "auth" },
      { name = "PORT", value = "80" },
    ]

    secrets = [
      {
        name      = "ROOT_AR_TOKEN",
        valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_ROOT_AR_TOKEN-jzvsbY"
      }
    ]

    health_check = {
      command     = ["CMD-SHELL", "curl -sf http://localhost:80/health || exit 1"]
      interval    = 60
      timeout     = 7
      retries     = 3
      startPeriod = 60
    }

    log_configuration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${env_name}-auth"
        awslogs-region        = "eu-west-3"  # Matches the region in the image
        awslogs-stream-prefix = "ecs"
        awslogs-create-group  = "true"
      }
    }

    port_mappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }
    ]

    # Additional load balancer specific configurations
    load_balancer = {
      type                = "application"
      scheme              = "internet-facing"
      ip_address_type     = "ipv4"
      internal            = false
      deletion_protection = false  # Adjust as needed
    }
  }
}