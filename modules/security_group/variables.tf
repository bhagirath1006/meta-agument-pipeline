variable "security_groups" {
  description = "Map of security groups to create using for_each"
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

variable "vpc_id" {
  description = "VPC ID to associate with security groups"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}
