variable "vpc_count" {
  description = "Number of VPCs to create"
  type        = number
  default     = 2
}

variable "cidr_prefix" {
  description = "CIDR prefix for VPCs"
  type        = string
  default     = "10"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}
