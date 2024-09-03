# modules/alb/main.tf

# Create a new Route53 hosted zone for the environment
resource "aws_route53_zone" "env_zone" {
  name = "${var.env_name}.assetreality.org"

  tags = merge(var.tags, {
    Name = "${var.env_name}-zone"
  })
}

# Create the ALBs
resource "aws_lb" "services" {
  for_each = toset(var.lb_services)

  name               = "${var.env_name}-${each.key}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb[each.key].id]
  subnets            = var.public_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.env_name}-${each.key}-lb"
  })
}

# Create security groups for ALBs
resource "aws_security_group" "lb" {
  for_each = toset(var.lb_services)

  name        = "${var.env_name}-${each.key}-lb-sg"
  description = "Security group for ${each.key} load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.env_name}-${each.key}-lb-sg"
  })
}

# Create A records in the new hosted zone
resource "aws_route53_record" "services" {
  for_each = aws_lb.services

  zone_id = aws_route53_zone.env_zone.id
  name    = "${each.key}.${var.env_name}.assetreality.org"
  type    = "A"

  alias {
    name                   = each.value.dns_name
    zone_id                = each.value.zone_id
    evaluate_target_health = true
  }
}

