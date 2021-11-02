terraform {
  /* Using the s3 bucket and dynamoDB connect Terraform Backend to AWS  */

  backend "s3" {
    profile        = "prod"
    bucket         = "brian-tf-state-123789654321"
    key            = "prod/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "brian-tf-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "prod"
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  allocated_storage   = 10
  engine              = "mysql"
  instance_class      = "db.t2.micro"
  name                = "example_db"
  username            = "admin"
  password            = local.db_creds.secret_id
  skip_final_snapshot = true
}

/* Secret configured in secret manager manually added  */
data "aws_secretsmanager_secret_version" "example" {
  secret_id = "mysql-master-password-stage1"
}
/* Decoding the JSON to be usuable  */
locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.example.secret_string
  )
}