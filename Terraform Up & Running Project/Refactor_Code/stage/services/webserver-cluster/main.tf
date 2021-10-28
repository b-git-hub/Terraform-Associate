terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}


/* Creating my template for scaling up and down */
resource "aws_launch_configuration" "example" {
  name            = "web_config"
  image_id        = "ami-00399ec92321828f5"
  instance_type   = "t2.micro"
  user_data       = <<-EOF
            #!/bin/bash
            echo "Fuck you James" > index.html
            nohup busybox httpd -f -p ${var.Port_Number} &
            EOF
  security_groups = [aws_security_group.http.id]

  lifecycle {
    create_before_destroy = true
  }
}

/* Data is a way to query the API for information you need to build */
data "aws_vpc" "selected" {
  default = true
}

/* Using the VPC ID gathered above to get the subnet information */
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id
}

output "alb_dns_name" {
  value       = aws_lb.lb.dns_name
  description = "Querying load balancer for its DNS name"
}



