variable "global_env" {
  description = "Global environment variables"
  type        = map(string)
  default     = {
    # Default key-value pairs for global environment variables
    email = "example@example.com"
    # Add more key-value pairs as needed
  }
}

##update to reflect your intended regions, in addition to invoking the api_lambda_service module for each region
variable "replicate_to_regions" {
  description = "List of regions where Lambda APIs are replicated"
  type        = list(string)
  default     = ["us-east-1", "us-east-2", "us-west-1", "us-west-2"]
}

variable "project_name" {
  description = "Name of the project"
  default     = "multi-regional-lambda"
  type        = string
}

variable "lambda_execution_role_name" {
  description = "Name of the Lambda execution role"
  default     = "lambda_exec_role"
  type        = string
}

variable "lambda_directory" {
  description = "Directory where Lambda function code resides"
  type        = string
  default     = "/services"
}