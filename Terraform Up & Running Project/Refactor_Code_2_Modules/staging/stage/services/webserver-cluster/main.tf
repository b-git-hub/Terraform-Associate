terraform {
  backend "s3" {
    bucket         = "brian-tf-state-123789654321"
    key            = "stage/data-stores/webserver-cluster/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "brian-tf-locks"
    encrypt        = true
    profile        = "prod"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "webservers-stage"
  db_remote_state_bucket = "brian-tf-state-123789654321"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 3

}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
  description = "Load balancer name pulled from module"
}