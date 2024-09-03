variable "broker_name" {
  type = string
}

variable "host_instance_type" {
  type = string
}
variable "rabbitmq_admin_password" {
  type = string
  description = "The password for the initial admin user for RabbitMQ"
 }

variable "environment" {
  type    = string
  default = "dr-sandbox"
}

variable "service" {
  type    = string
  default = "rabbitmq"
}

variable "users_file" {
  type        = string
  description = "Path to the JSON file containing user data"
}

