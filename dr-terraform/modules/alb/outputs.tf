# modules/alb/outputs.tf

output "alb_dns_names" {
  description = "DNS names of the created ALBs"
  value       = { for k, v in aws_lb.services : k => v.dns_name }
}

output "alb_zone_ids" {
  description = "Hosted zone IDs of the created ALBs"
  value       = { for k, v in aws_lb.services : k => v.zone_id }
}

output "alb_arns" {
  description = "ARNs of the created ALBs"
  value       = { for k, v in aws_lb.services : k => v.arn }
}

output "security_group_ids" {
  description = "IDs of the created security groups"
  value       = { for k, v in aws_security_group.lb : k => v.id }
}

output "route53_zone_id" {
  description = "ID of the created Route53 zone"
  value       = aws_route53_zone.env_zone.id
}

output "route53_name_servers" {
  description = "Name servers of the created Route53 zone"
  value       = aws_route53_zone.env_zone.name_servers
}