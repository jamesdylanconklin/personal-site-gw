variable "project_name" {
  description = "Name of the project, used for resource naming"
  type        = string
  default     = "personal-site-gw"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "hello_endpoint_count" {
  description = "Number of hello endpoints to create"
  type        = number
  default     = 3
}

variable "s3_blog_bucket_name" {
  description = "S3 bucket name for blog content"
  type        = string
}
