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

output "die_roller_endpoints" {
  description = "The Die Roller endpoint URLs"
  value = {
    for key, resource in module.die_roller.api_gateway_resources : 
    key =>"${aws_api_gateway_stage.main.invoke_url}${resource.path}"
  }
}


output "s3_fetch_endpoints" {
  description = "The S3 Fetch endpoint URLs"
  value = {
    for key, resource in module.s3_fetch.api_gateway_resources : 
    key =>"${aws_api_gateway_stage.main.invoke_url}${resource.path}"
  }
}

# output "s3_fetch_lambda_arn" {
#   description = "The ARN of the S3 fetch Lambda function"
#   value = module.s3_fetch.lambda_function_arn
# }