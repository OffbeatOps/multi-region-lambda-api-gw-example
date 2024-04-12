# Overview

This Terraform repository provides a streamlined approach to deploying serverless applications on AWS, leveraging Lambda functions, DynamoDB tables, and API Gateway. Additionally, it lays the foundation for a basic multi-region architecture, facilitating high availability and scalability.

## Key Components:

- **Lambda Functions:** Easily deploy Lambda functions by placing the function code files in the designated Lambda directory. Each subdirectory represents a separate Lambda function, with configurations dynamically populated from file/path attributes.

- **DynamoDB Tables:** Provision DynamoDB tables automatically, supporting global replication for multi-region deployments.

- **API Gateway Integration:** Simplify the integration of serverless functions with RESTful APIs by automatically provisioning API Gateway resources and methods for each Lambda function.

- **Multi-Region Setup:** Enable high availability and fault tolerance by configuring resources in multiple AWS regions. The primary region is designated, and replication to secondary regions is supported.

- **CloudFront Distribution:** While not directly included in this setup, it serves as a foundational building block for a multi-regional architecture. Further enhancements can be made by integrating a CloudFront distribution and/or Route53 latnecy .

![Multi-region Lambda Architecture](/images/multi-regional-lambda.jpg)