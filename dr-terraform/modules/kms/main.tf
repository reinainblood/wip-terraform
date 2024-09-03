# modules/kms/main.tf

resource "aws_kms_key" "multi_region_key" {
  description             = "Multi-region key for shared snapshots"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation     = true
  multi_region            = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

        {
          "Sid": "Permission to use IAM policies",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::${var.account_id}:root"
          },
          "Action": "kms:*",
          "Resource": "*"
        },
        {
          "Sid": "Allow parent account to use this KMS key",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::${var.parent_account_id}:root"
          },
          "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncryptFrom",
            "kms:ReEncryptTo",
            "kms:GenerateDataKey",
            "kms:GenerateDataKeyWithoutPlaintext",
            "kms:DescribeKey"
          ],
          "Resource": "*"
        }
      ]
  })

  tags = {
    Name = var.key_name
  }
}

resource "aws_kms_alias" "multi_region_key_alias" {
  name          = "alias/${var.key_name}"
  target_key_id = aws_kms_key.multi_region_key.key_id
}

data "aws_caller_identity" "current" {}





