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
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}enable_s3" {
  description = "Enable S3 bucket deployment"
  type        = bool
  default     = true
}

variable "s3_buckets" {
  description = "Map of S3 buckets to create"
  type = map(object({
    versioning = bool
  }))
  
  validation {
    condition     = length(var.s3_buckets) > 0
    error_message = "At least one S3 bucket must be defined."
  }
}

variable "enable_ec2" {
  description = "Enable EC2 instance deployment"
  type        = bool
  default     = true
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  
  validation {
    condition     = var.ec2_instance_count > 0 && var.ec2_instance_count <= 10
    error_message = "EC2 instance count must be between 1 and 10."
  }
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  
  validation {
    condition     = can(regex("^t[2-4]\\.", var.ec2_instance_type)) || can(regex("^m[5-7]\\.", var.ec2_instance_type))
    error_message = "Instance type must be t2/t3/t4 or m5/m6/m7 family."
  }