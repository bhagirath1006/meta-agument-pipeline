variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment (dev, uat, preprod, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "uat", "preprod", "prod"], var.environment)
    error_message = "Environment must be dev, uat, preprod, or prod."
  }
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_count" {
  description = "Number of VPCs to create (count example)"
  type        = number
  default     = 1
  validation {
    condition     = var.vpc_count > 0 && var.vpc_count <= 5
    error_message = "VPC count must be between 1 and 5."
  }
}

variable "security_groups" {
  description = "Security groups configuration (for_each example)"
  type = map(object({
    description = string
    ingress = list(object({
      protocol    = string
      from_port   = number
      to_port     = number
      cidr_blocks = list(string)
    }))
  }))
}

variable "s3_buckets" {
  description = "S3 buckets configuration (for_each example)"
  type = map(object({
    versioning = bool
  }))
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}
