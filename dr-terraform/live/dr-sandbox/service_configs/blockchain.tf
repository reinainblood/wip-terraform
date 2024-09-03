blockchain = {
  cpu            = 512
  memory         = 1024
  container_port = 5777
  image_tag      = "ce539766-blockchain"
  desired_count  = 1
  essential = true
  environment = [
    { name = "SERVICE_NAME", value = "blockchain" },
    { name = "PORT", value = "5777" },
  ]
  secrets = [
    {
      name      = "BLOCKDAEMON_API_KEY",
      valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_BLOCKDAEMON_API_KEY-JyOfp8"
    },
    {
      name      = "ANKR_API_KEY",
      valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_ANKR_API_KEY-d6ZLee"
    },
  ]
  health_check  = local.default_health_check
  port_mappings = [
    {
      name          = "blockchain-57777-tcp"
      containerPort = "5777"
      hostPort      = "5777"
      protocol      = "tcp"
    }
  ]
}
