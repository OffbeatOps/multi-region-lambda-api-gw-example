#iterate through functions map and create a service for each
resource "aws_lambda_function" "lambda_functions" {
  for_each = local.functions

  function_name    = "${each.key}_lambda"
  handler          = "${each.value.handler}.lambda_handler"
  role             = aws_iam_role.lambda_execution_role[each.key].arn
  runtime          = each.value.type
  filename         = each.value.filename
  source_code_hash = filebase64sha256(each.value.source)

  environment {
    variables = merge(
      #setting env vars from ssm_parameters
      {
        for item in var.function_parameters :
        upper(replace(item, "-", "_")) => aws_ssm_parameter.function_parameters[item].name
      },
      #setting dynamodb env var
      {
        DYNAMODB_TABLE = aws_ssm_parameter.lambda_dynamodb_table_parameters[each.key].value
      },
      ##use key=value pairs found in global_env
      var.global_env
    )
  }
}

resource "aws_lambda_permission" "api_gateway_lambda_permission" {
  for_each = local.functions

  statement_id  = each.key
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_functions[each.key].arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_iam_role" "lambda_execution_role" {
  for_each = local.functions
  name = "${each.value.role_name}_${data.aws_region.current.name}" #not idea, but simplifies the multi-region solution when global resources are involved. This at least doesn't cost anything.
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "dynamodb"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        "Sid"= "SpecificTable",
        "Effect"= "Allow",
        "Action"= [
          "dynamodb:BatchGet*",
          "dynamodb:DescribeStream",
          "dynamodb:DescribeTable",
          "dynamodb:Get*",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWrite*",
          "dynamodb:CreateTable",
          "dynamodb:Delete*",
          "dynamodb:Update*",
          "dynamodb:PutItem"
        ],
        "Resource"= aws_dynamodb_table.lambda_dynamodb_tables[each.key].arn
      }]})
  }
}

##stage ssm parameter for each lambda
resource "aws_ssm_parameter" "function_parameters" {
  for_each = local.functions

  name  = "/lambda/${each.key}"
  type  = "String"
  value = each.value.route
}

##iterate through the lambda_directory and zip each matching file
data "archive_file" "lambda_zips" {
  for_each = local.functions

  type        = "zip"
  source_file = each.value.source
  output_path = each.value.filename
}