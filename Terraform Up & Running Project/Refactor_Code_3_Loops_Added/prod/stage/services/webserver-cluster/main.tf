terraform {
  backend "s3" {
    profile        = "prod"
    bucket         = "brian-tf-state-123789654321"
    key            = "prod/data-stores/webserver-cluster/terraform.tfstate"
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
  region = "us-east-2"
  profile        = "prod"
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"
  cluster_name = "webservers-stage"
  db_remote_state_bucket = "brian-tf-state-123789654321"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale_out_during_business_hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence = "0 9 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name

}

resource "aws_autoscaling_schedule" "scale-in-at-night" {
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence = "0 17 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
  description = "Load balancer name pulled from module"
}