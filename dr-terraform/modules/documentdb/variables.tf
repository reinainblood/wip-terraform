

variable "cluster_identifier" {
  type = string
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}

variable "snapshot_identifier" {
  type = string
  description = "The identifier for the DB snapshot or DB cluster snapshot to restore from."
  default = null
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_class" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "db_subnet_group_name" {
  type = string
}