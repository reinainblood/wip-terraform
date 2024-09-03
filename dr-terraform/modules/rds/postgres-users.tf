# provider "postgresql" {
#   scheme    = "awspostgres"
#   host      = "db.domain.name"
#   port      = "5432"
#   username  = var.master_username
#   password  = var.master_password
#   superuser = false
# }
#
#
# resource "postgresql_role" "service_db_role" {
#   name                = "${var.service_name}-role"
#   login               = true
#   password            = "db_password"
#   encrypted_password  = true
# }
#
# resource "postgresql_database" "new_db" {
#   name              = "new_db"
#   owner             = postgresql_role.service_db_role.name
#   template          = "template0"
#   lc_collate        = "C"
#   connection_limit  = -1
#   allow_connections = true
# }
#
