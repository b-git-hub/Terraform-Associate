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
  name          = "web_config"
  image_id      = "ami-00399ec92321828f5"
  instance_type = "t2.micro"
  user_data              = <<-EOF
            #!/bin/bash
            echo "Hello, World. Suck a Dick Neal" > index.html
            nohup busybox httpd -f -p ${var.Port_Number} &
            EOF
  security_group = [aws_security_group.http.id]
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "dummy_server" {
  ami           = "ami-00399ec92321828f5" # us-west-2
  instance_type = "t2.micro"

  /* EOF allows multiple lines to be passed into the shell of the server, alternative to cloud-init
  Use interpolation to reference a variable inside a string */
  user_data              = <<-EOF
            #!/bin/bash
            echo "Hello, World. Suck a Dick Neal" > index.html
            nohup busybox httpd -f -p ${var.Port_Number} &
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

output "public_ip" {
  value = aws_instance.dummy_server.public_ip
}