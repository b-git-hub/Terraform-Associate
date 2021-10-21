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


resource "aws_instance" "dummy_server" {
  ami           = "ami-00399ec92321828f5" # us-west-2
  instance_type = "t2.micro"

  /* EOF allows multiple lines to be passed into the shell of the server, alternative to cloud-init */
  user_data              = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF
  vpc_security_group_ids = [aws_security_group.http.id]

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "http" {
  name        = "http"
  description = "Allow TLS inbound traffic"

  ingress = [
    {
      description      = "HTTP"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["217.43.36.244/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
}

output "public_ip" {
  value = aws_instance.dummy_server.public_ip
}