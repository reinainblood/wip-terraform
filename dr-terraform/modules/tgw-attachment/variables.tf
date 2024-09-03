variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tgw_subnet_count" {
  description = "Number of subnets to create for TGW attachment"
  type        = number
  default     = 3
}

variable "db_subnet_count" {
  description = "Number of subnets to create for databases"
  type        = number
  default     = 3
}

variable "ecs_subnet_count" {
  description = "Number of subnets to create for ECS cluster"
  type        = number
  default     = 3
}

variable "tgw_id" {
  description = "id of tgw in parent account"
  type = string

}

variable "env" {
  description = "Name of new env"
  type = string
}
variable "parent" {
  description = "Name of parent account with TGW"
  default = "dev"
}