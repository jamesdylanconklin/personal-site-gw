locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    Component   = "die-roller"
  }
}

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

  tags = local.common_tags
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    module.hello_endpoints,
    module.die_roller,
    module.s3_fetch
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

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_stage"
  })
}

# Demos parent resource
resource "aws_api_gateway_resource" "demos_parent" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "demos"
}

# Die roller endpoints using module from GitHub
module "die_roller" {
  source = "git::https://github.com/jamesdylanconklin/personal-site-demos.git//demos/lambda/die-roller?ref=jconk/lambdas/s3-fetch"

  parent_api_id      = aws_api_gateway_rest_api.main.id
  parent_resource_id = aws_api_gateway_resource.demos_parent.id
  environment        = var.environment
  project_name       = var.project_name
}

# Blog parent resource
resource "aws_api_gateway_resource" "blog_parent" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "blog"
}

# Blog s3-fetch endpoint
module "s3_fetch" {
  source = "git::https://github.com/jamesdylanconklin/personal-site-demos.git//demos/lambda/s3-fetch?ref=jconk/lambdas/s3-fetch"

  parent_api_id      = aws_api_gateway_rest_api.main.id
  parent_resource_id = aws_api_gateway_resource.blog_parent.id
  environment        = var.environment
  project_name       = var.project_name
  bucket_name        = var.s3_blog_bucket_name
}


# Hello parent resource
resource "aws_api_gateway_resource" "hello_parent" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "hello"
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

