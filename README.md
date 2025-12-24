## Architecture

This project implements a serverless REST API using AWS managed services.

Client requests are routed through Amazon API Gateway (REST), which invokes an AWS Lambda function using proxy integration. The Lambda function performs CRUD operations against a DynamoDB table and returns JSON responses.

All infrastructure is provisioned using Terraform with a modular design, enforcing least-privilege IAM roles and full infrastructure-as-code practices.

Components:
- API Gateway (REST)
- AWS Lambda (Python)
- DynamoDB
- IAM (least privilege)
- CloudWatch Logs
