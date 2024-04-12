locals {
  lambda_execution_role_name = var.lambda_execution_role_name
  
  #ignore zip files so subsequent executions don't fail. would prevent using zip as the extension type, but also that's not ideal for version control.
  lambda_files = [ for fn in fileset("${path.root}/${var.lambda_directory}", "**/*") : fn if !endswith(fn, ".zip") ]

  # This creates the functions map of services and related attributes by iterating through the lambda_directory
  functions = {
    for filepath in local.lambda_files : 
    basename(abspath(dirname(filepath))) => {
      # Determine the service directory from the file path
      service_dir = dirname(abspath(filepath))
      # Determine attributes for each service
      name        = basename(abspath(filepath))
      role_name   = "${local.lambda_execution_role_name}_${basename(abspath(dirname(filepath)))}"
      source      = "${path.root}/${var.lambda_directory}/${filepath}"
      handler     = join(", ", (regex("(.+)\\.[^.]+$", basename(abspath(filepath)))))
      filename = "${path.root}/${var.lambda_directory}/${dirname(filepath)}/${basename(abspath(dirname(filepath)))}_lambda.zip"

      # Determine the runtime based on the language_mapping
      type = join(", ", (matchkeys(values(var.language_mapping), keys(var.language_mapping), [regex("[.][^.]+$", filepath)])))
      route       = basename(abspath(filepath))
    }
  }
}

data "aws_region" "current" {}