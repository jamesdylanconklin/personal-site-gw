variable "rest_api_id" {
  description = "The ID of the REST API"
  type        = string
}

variable "parent_resource_id" {
  description = "The ID of the parent resource"
  type        = string
}

variable "path_part" {
  description = "The path part for this resource (e.g., '1', '2', etc.)"
  type        = string
}

variable "message" {
  description = "The message to return in the response"
  type        = string
}
