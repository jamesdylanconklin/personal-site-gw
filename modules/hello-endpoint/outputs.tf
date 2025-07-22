output "method_id" {
  description = "The ID of the API Gateway method"
  value       = aws_api_gateway_method.hello.id
}

output "resource_id" {
  description = "The ID of the API Gateway resource"
  value       = aws_api_gateway_resource.hello.id
}
