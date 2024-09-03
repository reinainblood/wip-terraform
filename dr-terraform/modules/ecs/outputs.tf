
output "cluster_id" {
  description = "ID of the created ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "cluster_name" {
  description = "Name of the created ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "service_discovery_namespace_id" {
  description = "ID of the created service discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.this.id
}

output "service_discovery_namespace" {
  description = "Name of the created service discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.this.name
}