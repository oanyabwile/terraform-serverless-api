# Terraform Serverless Tasks API

A production-style serverless REST API built on AWS using API Gateway, Lambda, and DynamoDB, fully provisioned with Terraform using a modular infrastructure-as-code design.

This project demonstrates modern cloud-native architecture patterns, event-driven compute, least-privilege IAM, and clean separation of application code and infrastructure.

---

## Architecture Overview

Client requests are routed through **Amazon API Gateway (REST)**, which invokes an **AWS Lambda** function using proxy integration. The Lambda function performs CRUD operations against a **DynamoDB** table and returns JSON responses.

All infrastructure is defined and managed using **Terraform**, following modular and environment-driven best practices.

### Components

- **API Gateway (REST)** – HTTP interface and routing  
- **AWS Lambda (Python)** – Stateless compute  
- **Amazon DynamoDB** – NoSQL persistence  
- **IAM** – Least-privilege execution roles and permissions  
- **CloudWatch Logs** – Centralized logging  
- **Terraform** – Infrastructure as Code  

---

## API Endpoints

| Method | Endpoint         | Description            |
|------|-------------------|------------------------|
| POST | `/tasks`          | Create a new task      |
| GET  | `/tasks`          | List all tasks         |
| GET  | `/tasks/{id}`     | Retrieve a single task |
| DELETE | `/tasks/{id}`  | Delete a task          |

Authentication is intentionally omitted to keep the focus on infrastructure and serverless architecture. Auth can be layered on later using IAM, Cognito, or JWT authorizers.

---

## Repository Structure

```text
terraform-serverless-api/
├── environments/
│   └── dev/
│       ├── main.tf
│       └── outputs.tf
│
├── modules/
│   ├── api-gateway/
│   ├── lambda/
│   └── dynamodb/
│
├── src/
│   └── handler.py
│
└── README.md
```
## Design Notes

- **Application source code** lives in `src/`
- **Infrastructure definitions** live in `modules/`
- **Build artifacts** (Lambda zip files) are generated locally and ignored by Git
- Root environments control which outputs are exposed

---

## Infrastructure Highlights

- Fully modular Terraform codebase  
- Stateless Lambda design  
- DynamoDB table with on-demand billing  
- Explicit API Gateway REST resources and methods  
- Lambda proxy integration (no mapping templates)  
- Least-privilege IAM policies scoped to required services only  
- Clean environment separation  

---

## Deployment Workflow
All infrastructure is deployed via Terraform using a remote AWS backend.

### 1. Package Lambda source code
```bash
zip -j modules/lambda/lambda.zip src/handler.py
```

### 2. Deploy infrastructure
```bash
cd environments/dev
terraform init
terraform apply
```
### 3. Retrieve API endpoint
```bash
terraform output api_invoke_url
```

## Example Usage
### Create a task
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"title":"First task","description":"It works"}' \
  <API_INVOKE_URL>/tasks
```
### List tasks
```bash
curl <API_INVOKE_URL>/tasks
```
## Key Learnings Demonstrated
- Serverless REST API design
- Event-driven compute with AWS Lambda
- Proper API Gateway REST configuration
- Terraform module composition and output re-exporting
- Clear separation of source code, infrastructure, and build artifacts
- Real-world debugging of API Gateway + Lambda integrations










