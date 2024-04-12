output "lambda_function_arns" {
  value = [for func in aws_lambda_function.lambda_functions : func.arn]
}

output "api_gateway_resource_paths" {
  value = [for name, function in local.functions : function.route]
}

output "lambda_files" {
  value = local.lambda_files
}

output "functions_debug" {
  value = local.functions
}

output "api_gateway_url" {
  description = "URL for accessing the API Gateway endpoint"
  value       = aws_apigatewayv2_api.lambda.api_endpoint
}

output "stage_invoke_url" {
  description = "Invoke URL for the API Gateway stage"
  value       = aws_apigatewayv2_stage.lambda.invoke_url
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch Log Group for API Gateway"
  value       = aws_cloudwatch_log_group.api_gw.arn
}