output "bucket_names" {
  description = "S3 bucket names"
  value = {
    for key, bucket in aws_s3_bucket.main : key => bucket.id
  }
}

output "bucket_arns" {
  description = "S3 bucket ARNs"
  value = {
    for key, bucket in aws_s3_bucket.main : key => bucket.arn
  }
}

output "bucket_regions" {
  description = "S3 bucket regions"
  value = {
    for key, bucket in aws_s3_bucket.main : key => bucket.region
  }
}

output "bucket_name" {
  description = "First bucket name"
  value       = try(values(aws_s3_bucket.main)[0].id, "")
}
