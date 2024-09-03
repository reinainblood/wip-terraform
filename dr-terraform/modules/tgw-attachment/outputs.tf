output "tgw_subnet_ids" {
  value = aws_subnet.tgw_subnets[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db_subnets[*].id
}

output "ecs_subnet_ids" {
  value = aws_subnet.ecs_subnets[*].id
}