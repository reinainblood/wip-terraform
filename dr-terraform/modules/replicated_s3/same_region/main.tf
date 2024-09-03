
# Data source to get the source bucket
data "aws_s3_bucket" "source" {
  bucket   = var.source_bucket_name
}

# Create the destination bucket
resource "aws_s3_bucket" "destination" {
  bucket   = var.destination_bucket_name
}

# Copy bucket policy
resource "aws_s3_bucket_policy" "destination" {
  bucket   = aws_s3_bucket.destination.id
  policy   = data.aws_s3_bucket.source.policy
}

# Copy bucket versioning
resource "aws_s3_bucket_versioning" "destination" {
  bucket   = aws_s3_bucket.destination.id
  versioning_configuration {
    status = data.aws_s3_bucket.source.versioning[0].status
  }
}

# Copy bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "destination" {
  bucket   = aws_s3_bucket.destination.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = data.aws_s3_bucket.source.server_side_encryption_configuration[0].rule[0].apply_server_side_encryption_by_default[0].sse_algorithm
    }
  }
}

# Set up bucket replication
resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket   = data.aws_s3_bucket.source.id
  role     = aws_iam_role.replication.arn

  rule {
    id     = "ReplicateEverything"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}

# IAM role for replication
resource "aws_iam_role" "replication" {
  name     = "s3-bucket-replication-${var.source_bucket_name}-to-${var.destination_bucket_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for replication
resource "aws_iam_role_policy" "replication" {
  name     = "s3-bucket-replication-policy"
  role     = aws_iam_role.replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          data.aws_s3_bucket.source.arn
        ]
      },
      {
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Effect = "Allow"
        Resource = [
          "${data.aws_s3_bucket.source.arn}/*"
        ]
      },
      {
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.destination.arn}/*"
        ]
      }
    ]
  })
}





