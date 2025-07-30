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
    roll_basic = "${aws_api_gateway_stage.main.invoke_url}/demos/roll"
    roll_with_params = "${aws_api_gateway_stage.main.invoke_url}/demos/roll/{rollString}"
  }
}

output "die_roller_lambda_arn" {
  description = "The ARN of the die roller Lambda function"
  value = module.die_roller.lambda_function_arn
}