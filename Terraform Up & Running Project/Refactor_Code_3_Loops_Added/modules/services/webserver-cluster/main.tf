
/* Calling another state file into this enviroment  */
data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = "us-east-2"
  }
}


/* Calling the BASH file to run in the server you have to tell terraform to use the directory of the module by default it'll use where ever you run the file  */
data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
  vars = {
    server_ports = var.Port_Number
    db_port      = data.terraform_remote_state.db.outputs.port
    db_address   = data.terraform_remote_state.db.outputs.address
  }
}

/* Creating my template for scaling up and down */
resource "aws_launch_configuration" "example" {
  name            = "web_config"
  image_id        = "ami-00399ec92321828f5"
  instance_type   = var.instance_type
  user_data       = data.template_file.user_data.rendered
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

output "SQL_Ports" {
  value = data.terraform_remote_state.db.outputs.port
}


