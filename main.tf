terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  # Pull region, auth from sso profile.
}

# API Gateway
resource "aws_api_gateway_rest_api" "main" {
  name        = "${var.project_name}_${var.environment}"
  description = "API Gateway for ${var.project_name}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name        = "${var.project_name}_${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    module.hello_endpoints,
    module.die_roller,
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id

  lifecycle {
    create_before_destroy = true
  }
}

# API Gateway Stage
resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.environment

  tags = {
    Name        = "${var.project_name}_${var.environment}_stage"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Hello parent resource
resource "aws_api_gateway_resource" "hello_parent" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "hello"
}

# Demos parent resource
resource "aws_api_gateway_resource" "demos_parent" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "demos"
}

# Hello endpoints using module
module "hello_endpoints" {
  source = "./modules/hello-endpoint"
  count  = var.hello_endpoint_count

  rest_api_id        = aws_api_gateway_rest_api.main.id
  parent_resource_id = aws_api_gateway_resource.hello_parent.id
  path_part          = tostring(count.index + 1)
  message            = "Hello World ${count.index + 1}!"
}

# Die roller endpoints using module from GitHub
module "die_roller" {
  source = "git::https://github.com/jamesdylanconklin/personal-site-demos.git//demos/lambda/die-roller?ref=jconk/lambdas/roll"

  parent_api_id      = aws_api_gateway_rest_api.main.id
  parent_resource_id = aws_api_gateway_resource.demos_parent.id
}
