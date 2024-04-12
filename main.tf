#primary region
module "lambda_api_us_west_1" {
  source                      = "./modules/api_lambda_service"
  lambda_directory            = var.lambda_directory
  project_name                = var.project_name
  lambda_execution_role_name  = var.lambda_execution_role_name
  global_env                  = var.global_env
  primary_region              = true
  replicate_to_regions        = var.replicate_to_regions 
}

#secondary region
module "lambda_api_us_east_1" {
  source                      = "./modules/api_lambda_service"
  lambda_directory            = var.lambda_directory
  project_name                = var.project_name
  lambda_execution_role_name  = var.lambda_execution_role_name
  global_env                  = var.global_env
  secondary_region            = true
  providers = {
    aws = aws.us-east-1
  }
}

#secondary region
module "lambda_api_us_east_2" {
  source                      = "./modules/api_lambda_service"
  lambda_directory            = var.lambda_directory
  project_name                = var.project_name
  lambda_execution_role_name  = var.lambda_execution_role_name
  global_env                  = var.global_env
  secondary_region            = true
  providers = {
    aws = aws.us-east-2
  }
}

#secondary region
module "lambda_api_us_west_2" {
  source                      = "./modules/api_lambda_service"
  lambda_directory            = var.lambda_directory
  project_name                = var.project_name
  lambda_execution_role_name  = var.lambda_execution_role_name
  global_env                  = var.global_env
  secondary_region            = true
  providers = {
    aws = aws.us-west-2
  }
}