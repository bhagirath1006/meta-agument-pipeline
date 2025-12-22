output "vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.main[0].id, "")
}

output "vpc_ids" {
  description = "All VPC IDs"
  value       = aws_vpc.main[*].id
}

output "cidr_block" {
  description = "VPC CIDR block"
  value       = try(aws_vpc.main[0].cidr_block, "")
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = aws_subnet.main[*].id
}

output "internet_gateway_ids" {
  description = "Internet Gateway IDs"
  value       = aws_internet_gateway.main[*].id
}
