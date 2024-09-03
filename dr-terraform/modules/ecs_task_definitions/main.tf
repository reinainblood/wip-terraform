
# IAM Role for ECS Tasks

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.env_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "${var.env_name}-ecs-task-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Action" : "*",
            "Effect" : "Allow",
            "Resource" : "*"
          }
        ]
      }
    ]
  })
}
resource "aws_ecs_task_definition" "this" {
  for_each = var.all_services

  family                   = "${var.env_name}-${each.key}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name         = each.key
    image        = "${var.ecr_repository_url}:${each.value.image_tag}"
    cpu          = each.value.cpu
    memory       = each.value.memory
    essential    = true
    portMappings = each.value.port_mappings
    environment  = each.value.environment
    secrets      = each.value.secrets
    healthCheck  = each.value.health_check
    logConfiguration = each.value.log_configuration
  }])

  tags = merge(
    var.tags,
    {
      Name = "${var.env_name}-${each.key}"
    }
  )
}

resource "aws_ecs_service" "this" {
  for_each = var.all_services

  name            = "${var.env_name}-${each.key}"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this[each.key].arn
  desired_count   = each.value.desired_count

  launch_type         = "FARGATE"
  platform_version    = "LATEST"
  scheduling_strategy = "REPLICA"

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = false
    security_groups  = [var.security_group_id]
  }

  # Add load balancer configuration only for services in the create_alb list
  dynamic "load_balancer" {
    for_each = contains(var.create_alb, each.key) ? [1] : []
    content {
      target_group_arn = var.target_group_arns[each.key]
      container_name   = each.key
      container_port   = each.value.container_port
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env_name}-${each.key}"
    }
  )
}