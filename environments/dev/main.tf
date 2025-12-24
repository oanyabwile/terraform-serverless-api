terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "dev"
}

module "tasks_table" {
  source = "../../modules/dynamodb"

  table_name = "tasks-dev"

  tags = {
    Project     = "terraform-serverless-api"
    Environment = "dev"
  }
}

module "tasks_lambda" {
  source = "../../modules/lambda"

  function_name = "tasks-api-dev"

  table_name = module.tasks_table.table_name
  table_arn  = module.tasks_table.table_arn

  tags = {
    Project     = "terraform-serverless-api"
    Environment = "dev"
  }
}
