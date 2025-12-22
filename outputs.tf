output "vpc_ids" {
  description = "VPC IDs"
  value       = module.vpc[*].vpc_id
}

output "security_group_ids" {
  description = "Security group IDs"
  value = {
    for key, sg in module.security_group : key => sg.security_group_ids[key]
  }
}

output "ec2_instance_ids" {
  description = "EC2 instance IDs"
  value       = module.ec2[0].instance_ids
}

output "s3_bucket_names" {
  description = "S3 bucket names"
  value = {
    for key, bucket in module.s3 : key => bucket.bucket_name
  }
}
