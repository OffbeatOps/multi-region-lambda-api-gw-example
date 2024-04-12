resource "aws_apigatewayv2_api" "lambda" {
  name           = "${var.project_name}_${data.aws_region.current.name}_api_gateway"
  protocol_type  = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id         = aws_apigatewayv2_api.lambda.id
  name           = "${var.project_name}_${data.aws_region.current.name}_serverless_lambda_stage"
  auto_deploy    = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

#create integration for each service
resource "aws_apigatewayv2_integration" "lambda_integration" {
  for_each             = local.functions
  api_id               = aws_apigatewayv2_api.lambda.id
  integration_type     = "AWS_PROXY"
  integration_uri      = aws_lambda_function.lambda_functions[each.key].invoke_arn
  integration_method   = "POST"
}

#create route for each service
resource "aws_apigatewayv2_route" "lambda_route" {
  for_each    = local.functions
  api_id      = aws_apigatewayv2_api.lambda.id
  route_key   = "POST /${each.key}"
  target      = "integrations/${aws_apigatewayv2_integration.lambda_integration[each.key].id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name                = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"
  retention_in_days   = var.log_retention
}