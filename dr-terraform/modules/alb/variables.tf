# modules/alb/variables.tf

variable "env_name" {
  description = "Name of the environment (e.g., dr-sandbox)"
  type        = string
}

variable "lb_services" {
  description = "List of services that need load balancers"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}



variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}