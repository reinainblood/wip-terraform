# variables.tf

variable "env" {
  type = string
  description = "Enviornment name"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "azs" {
  type = list(string)
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}



variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets"
  type        = bool
  default     = false
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "main-vpc"
}

