# output "docdb_endpoint" {
#   value = module.docdb.cluster_endpoint
# }
# output "copied_buckets" {
#   description = "List of buckets that were copied"
#   value       = [for bucket in module.s3_bucket_copy : bucket.destination_bucket_id]
# }
# output "service_discovery_namespace" {
#   value       = local.actual_service_discovery_namespace
#   description = "The actual service discovery namespace created by the ECS module"
# }
# output "docdb_secret_arn" {
#   value = jsondecode(data.aws_secretsmanager_secret.docdb)
#
# }
# output "ecs_cluster_id" {
#   description = "The ID of the ECS cluster"
#   value       = module.ecs.cluster_id
# }
#
# output "ecs_cluster_name" {
#   description = "The name of the ECS cluster"
#   value       = module.ecs.cluster_name
# }
#
# output "ecs_task_definitions" {
#   description = "ARNs of the task definitions"
#   value       = module.ecs.task_definitions
# }
#
# output "ecs_services" {
#   description = "Details of the ECS services"
#   value       = module.ecs.services
# }
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