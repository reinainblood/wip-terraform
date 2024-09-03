resource "aws_ecs_cluster" "this" {
  name = "${var.env_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env_name}-cluster"
    }
  )
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "${var.env_name}.local"
  description = "Private DNS namespace for ECS services in ${var.env_name}"
  vpc         = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.env_name}-service-discovery-namespace"
    }
  )
}