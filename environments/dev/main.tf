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
