## How to Use
Simply add folders and functions to the lambda_directory as defined in variables.tf. The module will iterate through the directory to determine naming, lambda attributes, etc.

main.tf in the parent module demonstrates deploying into 4 regions. When deploying into multiple regions, the module will create a global dynanmodb table. Ideally there is also a cloudfront distribution serving each regional api-gateway endpoint.

## Key Features:

### Dynamic Function Deployment
The module dynamically deploys Lambda functions based on the files present in the specified Lambda directory. It supports multiple programming languages by mapping file extensions to corresponding Lambda runtimes using the `language_mapping` variable.

- **Configuration:** Define your serverless functions by placing the function code files in the designated Lambda directory. Each child directory under var.lambda_directory represents a separate Lambda function.
- **Runtime Mapping:** The `language_mapping` variable allows you to specify the runtime for each supported file extension, ensuring that the correct runtime environment is used for each function.

### Flexible Configuration
Function configurations such as function name, handler, runtime, and environment variables are dynamically derived from file attributes and SSM parameters, enabling flexible and efficient management of serverless applications.

- **Handler and Runtime:** The module extracts the handler function and runtime from each function's file path and maps them to the corresponding Lambda function configuration.
- **SSM Parameter Integration:** Configuration parameters such as email addresses, table names, and API keys are stored securely in AWS Systems Manager (SSM) Parameter Store. The module retrieves these parameters dynamically during deployment, allowing for centralized and secure configuration management.

### API Gateway Integration
The module automatically provisions API Gateway resources and methods for each Lambda function, allowing easy integration of serverless functions with RESTful APIs.

- **RESTful API Endpoints:** API Gateway resources and methods are automatically created for each Lambda function, enabling seamless integration of serverless functions with RESTful APIs.
- **Simplified Configuration:** Eliminate the need for manual configuration of API Gateway resources and methods by leveraging the module's automatic provisioning capabilities.

### Automatic Multi-Region Configuration
The module supports automatic configuration of resources in multiple AWS regions, ensuring high availability and fault tolerance for serverless applications.

### CloudFront Distribution Integration
This setup serves as the foundational building blocks for a multi-regional architecture that can be further enhanced with a CloudFront distribution. 

![Alt text](/images/multi-regional-lambda.jpg?raw=true "Multi-region Lambda")
- **Primary Region:** Define the primary region using the `primary_region` boolean in the module configuration. The dynamodb_global_table will be provisioned from this module.
- **Secondary Regions:** Additional regions can be specified using the `replicate_to_regions` parameter.