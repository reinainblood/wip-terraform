variable "key_name" {
  description = "The name of the KMS key"
  type        = string
}
variable "parent_account_id" {
  description = "The accound id of the account hosting the snapshot etc that needs to be encrypted/decrypted"
  type = number
}
variable "account_id" {
  description = "The aws account id of the current (new) account"
  type = number
}
variable "key_region" {
  default = "us-east-1"
  type = string
}