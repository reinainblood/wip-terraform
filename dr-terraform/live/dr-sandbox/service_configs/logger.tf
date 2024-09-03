locals {
logger = {
  cpu            = 512
  memory         = 1024
  image_tag = "ce539766-logger"
  container_port = 5009
  desired_count  = 1
  essential = true
  environment = [
    { name = "SERVICE_NAME", value = "logger" },
    { name = "PORT", value = tostring(local.service_ports.logger) },
  ]
  health_check  = local.default_health_check
  port_mappings = [
    {
      name          = "logger-5009-tcp"
      containerPort = 5009
      hostPort      = 5009
      protocol      = "tcp"
    }
  ]
  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = "${env_name}-asset-reality-logger-logs"
      awslogs-region        = "${aws_region}"
      awslogs-stream-prefix = "ecs-logger"

    }
  }
}
}
