resource "aws_api_gateway_rest_api" "this" {
  name = var.api_name
  tags = var.tags
}

resource "aws_api_gateway_resource" "tasks" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "tasks"
}

resource "aws_api_gateway_resource" "task_id" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.tasks.id
  path_part   = "{id}"
}

locals {
  tasks_methods    = ["GET", "POST"]
  task_id_methods  = ["GET", "DELETE"]
}

resource "aws_api_gateway_method" "tasks" {
  for_each = toset(local.tasks_methods)

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.tasks.id
  http_method   = each.key
  authorization = "NONE"
}

resource "aws_api_gateway_method" "task_id" {
  for_each = toset(local.task_id_methods)

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.task_id.id
  http_method   = each.key
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "tasks" {
  for_each = aws_api_gateway_method.tasks

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.tasks.id
  http_method = each.value.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_integration" "task_id" {
  for_each = aws_api_gateway_method.task_id

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.task_id.id
  http_method = each.value.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [
    aws_api_gateway_integration.tasks,
    aws_api_gateway_integration.task_id
  ]
}

resource "aws_api_gateway_stage" "this" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id

  tags = var.tags
}
