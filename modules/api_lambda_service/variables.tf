variable "global_env" {
  description = "Global environment variables"
  type        = map(string)
  default     = {
    # Default key-value pairs for global environment variables
    email = "example@example.com"
    # Add more key-value pairs as needed
  }
}

variable "replicate_to_regions" {
  description = "List of regions to replicate DynamoDB global table to"
  type        = list(string)
  default     = null
}

variable "secondary_region" {
  description = "boolean to account for multi-region"
  type        =  bool
  default     =  false
}

variable "primary_region" {
  description = "boolean to account for multi-region"
  type        =  bool
  default     =  false
}

variable "lambda_directory" {
  description = "Path to the directory containing Lambda function code"
}

variable "project_name" {
  description = "Name of the project"
}

variable "log_retention" {
  description = "Log Retention in Days"
  type        = string
  default     = "30"
}

variable "lambda_execution_role_name" {
  description = "Name of the IAM role for Lambda execution"
}

variable "function_parameters" {
  description = "A set of SSM parameter names to be precreated for the function (env variables will be precreated as well)"
  type        = set(string)
  default     = []
}

variable "e-mail" {
  description = "E-mail env variable"
  type        = string
  default     = "example@example.com"
}

###predetermine the type of lambda
variable "language_mapping" {
  type       = map(string)
  default    = {
    ".py"    = "python3.8"
    ".js"    = "nodejs20.x"
    ".ts"    = "nodejs20.x"
    ".java"  = "java11"
    ".jar"   = "java11"
    ".go"    = "go1.x"
    ".rb"    = "ruby2.7"
    ".php"   = "provided.al2023"  # PHP functions require a custom runtime
    ".sh"    = "provided.al2023"   # Shell scripts require a custom runtime
    ".pl"    = "provided.al2023"   # Perl scripts require a custom runtime
    ".swift" = "provided.al2023"  # Swift functions require a custom runtime
    // Add mappings for other file extensions as needed
  }
}