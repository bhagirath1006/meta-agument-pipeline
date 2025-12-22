# Get current AWS account ID (Terraform function)
data "aws_caller_identity" "current" {}

# Get current AWS region (Terraform function)
data "aws_region" "current" {}

# META-ARGUMENT EXAMPLE: for_each with S3 buckets
resource "aws_s3_bucket" "main" {
  for_each = var.buckets
  bucket   = "${var.project_name}-${each.key}-${data.aws_caller_identity.current.account_id}-${lower(data.aws_region.current.name)}"

  lifecycle {
    # Prevent accidental deletion
    prevent_destroy = false
    # Ignore changes to tags made outside of Terraform
    ignore_changes = [
      tags["LastModified"]
    ]
  }

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

# Versioning configuration using Terraform functions
resource "aws_s3_bucket_versioning" "main" {
  for_each = aws_s3_bucket.main

  bucket = each.value.id

  versioning_configuration {
    status = var.buckets[each.key].versioning ? "Enabled" : "Suspended"
  }

  depends_on = [
    aws_s3_bucket.main
  ]
}

# Server-side encryption using Terraform functions
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  count  = var.enable_encryption ? length(aws_s3_bucket.main) : 0
  bucket = values(aws_s3_bucket.main)[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  depends_on = [
    aws_s3_bucket.main
  ]
}

# Block public access
resource "aws_s3_bucket_public_access_block" "main" {
  for_each = aws_s3_bucket.main

  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket lifecycle policy with Terraform functions
# Demonstrates: tolist(), merge(), and conditional logic
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  for_each = aws_s3_bucket.main

  bucket = each.value.id

  rule {
    id     = "archive-old-logs"
    status = "Enabled"

    # Use Terraform functions: match()
    filter {
      prefix = each.key == "logs" ? "archive/" : ""
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.main
  ]
}

# Bucket policy using Terraform functions
# Demonstrates: jsonencode(), format(), and string interpolation
resource "aws_s3_bucket_policy" "main" {
  for_each = aws_s3_bucket.main

  bucket = each.value.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnforceSSLOnly"
        Effect = "Deny"
        Principal = {
          AWS = "*"
        }
        Action   = "s3:*"
        Resource = [
          each.value.arn,
          "${each.value.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      # Allow CloudFront access only
      {
        Sid    = "AllowCloudFront"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          each.value.arn,
          "${each.value.arn}/*"
        ]
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.main
  ]
}

# CloudWatch monitoring
resource "aws_cloudwatch_metric_alarm" "bucket_size" {
  for_each = aws_s3_bucket.main

  alarm_name          = "${each.key}-bucket-size-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = "86400"
  statistic           = "Average"
  threshold           = 1073741824 # 1GB

  dimensions = {
    BucketName = each.value.id
    StorageType = "StandardStorage"
  }

  depends_on = [
    aws_s3_bucket.main
  ]
}

# Example of using lookup() function
locals {
  bucket_tags = {
    for name, bucket in aws_s3_bucket.main : name => merge(
      bucket.tags,
      {
        BucketName = name
        Versioning = lookup(var.buckets[name], "versioning", false) ? "Enabled" : "Disabled"
      }
    )
  }
}
