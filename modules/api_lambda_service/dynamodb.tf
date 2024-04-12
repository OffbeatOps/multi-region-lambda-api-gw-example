#create dynamodb_table for each service
resource "aws_dynamodb_table" "lambda_dynamodb_tables" {
  for_each = local.functions

  name           = "${each.key}_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }

  #only enable streaming if we are targeting multi-region
  stream_enabled = var.primary_region || var.secondary_region
  stream_view_type = var.primary_region || var.secondary_region ? "NEW_AND_OLD_IMAGES" : null
}

#create ssm_parameter for each service
resource "aws_ssm_parameter" "lambda_dynamodb_table_parameters" {
  for_each = aws_dynamodb_table.lambda_dynamodb_tables

  name  = "/lambda/${each.key}/dynamodb_table"
  type  = "String"
  value = each.value.name
}

#create global table if this is the 'primary' region.
resource "aws_dynamodb_global_table" "table" {
  #ternary combined with for_each to only iterate through functions if this is the primary region
  for_each = var.primary_region ? local.functions : {} 
  name = aws_dynamodb_table.lambda_dynamodb_tables[each.key].name
  dynamic "replica" {
    for_each = var.replicate_to_regions

    content {
      region_name = replica.value
    }
  }
}