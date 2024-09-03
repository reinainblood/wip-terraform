
output "destination_bucket_id" {
  description = "The name of the destination bucket"
  value       = aws_s3_bucket.destination.id
}

output "destination_bucket_arn" {
  description = "The ARN of the destination bucket"
  value       = aws_s3_bucket.destination.arn
}