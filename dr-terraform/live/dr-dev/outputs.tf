output "docdb_endpoint" {
  value = module.docdb.cluster_endpoint
}
output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_task_definitions" {
  description = "ARNs of the task definitions"
  value       = module.ecs.task_definitions
}

output "ecs_services" {
  description = "Details of the ECS services"
  value       = module.ecs.services
}
# output "postgres_endpoint" {
#   value = module.rds.db_endpoint
# }
#
# output "rabbitmq_broker_id" {
#   value = module.amazon_mq.broker_id
# }
#
# output "redis_endpoint" {
#   value = module.elasticache_redis.cache_nodes[0].address
# }
#
# output "ecs_cluster_name" {
#   value = module.ecs_cluster.cluster_name
# }