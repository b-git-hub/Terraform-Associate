/* Provided in Hashicorp Documentation to connect to AWS*/
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "my-workspace"

    workspaces {
      name = "getting-started"
    }
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

