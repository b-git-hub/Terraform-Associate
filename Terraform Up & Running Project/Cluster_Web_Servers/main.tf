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
  name           = "web_config"
  image_id       = "ami-00399ec92321828f5"
  instance_type  = "t2.micro"
  user_data      = <<-EOF
            #!/bin/bash
            echo "Hello, World. Suck a Dick Neal" > index.html
            nohup busybox httpd -f -p ${var.Port_Number} &
            EOF
  security_groups = [aws_security_group.http.id]

  lifecycle {
    create_before_destroy = true
  }
}

/* Setting my scaling group to deploy */
resource "aws_autoscaling_group" "bar" {
  max_size            = 10
  min_size            = 2
  vpc_zone_identifier = data.aws_subnet_ids.private.ids
  launch_configuration     = aws_launch_configuration.example.name

  tag {
    key                 = "Name"
    value               = "EC2-Web-Server"
    propagate_at_launch = true
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

/* Definining the security group for inbound connections   */
resource "aws_security_group" "http" {
  name        = "http"
  description = "Allow TLS inbound traffic"

  ingress = [
    {
      description      = "HTTP"
      from_port        = var.Port_Number
      to_port          = var.Port_Number
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

}

