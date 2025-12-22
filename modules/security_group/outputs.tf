output "security_group_ids" {
  description = "Security group IDs created with for_each"
  value = {
    for key, sg in aws_security_group.main : key => sg.id
  }
}

output "security_group_arns" {
  description = "Security group ARNs"
  value = {
    for key, sg in aws_security_group.main : key => sg.arn
  }
}
