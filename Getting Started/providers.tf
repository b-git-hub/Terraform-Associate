/* Provided in Hashicorp Documentation to connect to AWS*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}


/* Declare based on your provider above some variable to were to connect. Here is us-east-2*/
provider "aws" {
  profile = "default"
  region  = "us-east-2"
  alias = "us-east"
}

/* If you deploy to multiple regions in the same provider use alias */
provider "aws" {
  profile = "default"
  region  = "eu-west-1"
  alias = "eu-west"
}
