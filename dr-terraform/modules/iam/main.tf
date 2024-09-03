
resource "aws_iam_role" "terraform_runner" {
  name = "terraform-runner"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.account_id
        }
      }
    ]
  })

  tags = {
    Name = "Terraform Runner Role"
  }
}

resource "aws_iam_policy" "admin_policy" {
  name        = "terraform-runner-admin-policy"
  path        = "/"
  description = "Admin policy for Terraform Runner role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": "*",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_policy_attach" {
  role       = aws_iam_role.terraform_runner.name
  policy_arn = aws_iam_policy.admin_policy.arn
}




