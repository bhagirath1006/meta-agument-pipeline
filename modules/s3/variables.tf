variable "buckets" {
  description = "Map of S3 buckets to create using for_each"
  type = map(object({
    versioning = bool
  }))
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "enable_encryption" {
  description = "Enable S3 bucket encryption"
  type        = bool
  default     = true
}
