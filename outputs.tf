output "api_gateway_url" {
  description = "The URL of the API Gateway"
  value       = aws_api_gateway_stage.main.invoke_url
}

output "api_gateway_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.main.id
}

output "hello_endpoint" {
  description = "The Hello endpoint URLs"
  value = [
    for endpoint in module.hello_endpoints :
    "${aws_api_gateway_stage.main.invoke_url}${endpoint.resource_path}"
  ]
}