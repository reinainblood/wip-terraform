variable "source_region" {
  description = "The region of the source bucket"
  type        = string
}

variable "destination_region" {
  description = "The region where the new bucket should be created"
  type        = string
}

variable "source_bucket_name" {
  description = "The name of the source bucket"
  type        = string
}

variable "destination_bucket_name" {
  description = "The name of the new bucket to be created"
  type        = string
}