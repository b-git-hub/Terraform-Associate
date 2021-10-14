/*Connectiong to Terraform Cloud to store the state file */
terraform {
  backend "remote" {
    organization = "my-workspace"

    workspaces {
      name = "getting-started"
    }
  }
/* Provided in Hashicorp Documentation to connect to AWS*/
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

