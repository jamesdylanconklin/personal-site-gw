# Hello resource
resource "aws_api_gateway_resource" "hello" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_resource_id
  path_part   = var.path_part
}

# Hello method
resource "aws_api_gateway_method" "hello" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.hello.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.hello.id
  http_method = aws_api_gateway_method.hello.http_method

  type = "MOCK"
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "hello" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.hello.id
  http_method = aws_api_gateway_method.hello.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "hello" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.hello.id
  http_method = aws_api_gateway_method.hello.http_method
  status_code = aws_api_gateway_method_response.hello.status_code

  response_templates = {
    "application/json" = jsonencode({
      message   = var.message
      timestamp = "$context.requestTime"
    })
  }
}
