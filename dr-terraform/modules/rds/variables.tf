variable "rds_cluster_identifier" {
  type = string
}
variable "db_subnet_group_name" {
  type = string
}
variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}

variable "rds_vpc_security_group_ids" {
  type = list(string)
}

variable "rds_cluster_snapshot_identifier" {
  type = string
}
variable "env_name" {
  type = string
}

