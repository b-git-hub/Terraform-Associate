terraform {
  /*
  backend "remote" {
    organization = "my-workspace"

    workspaces {
      name = "provisioner"
    }
  }
  */
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}