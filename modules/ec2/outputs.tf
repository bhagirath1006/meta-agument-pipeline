output "instance_id" {
  description = "EC2 instance IDs"
  value       = try(aws_instance.main[0].id, "")
}

output "instance_ids" {
  description = "All EC2 instance IDs"
  value       = aws_instance.main[*].id
}

output "instance_ips" {
  description = "Private IP addresses of instances"
  value       = aws_instance.main[*].private_ip
}

output "iam_role_arn" {
  description = "IAM role ARN"
  value       = aws_iam_role.main.arn
}
