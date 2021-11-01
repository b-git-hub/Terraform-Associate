/* Creating the load balancer  telling it it's IPs and security groups  */
resource "aws_lb" "lb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = data.aws_subnet_ids.private.ids

  enable_deletion_protection = false
}
/* Defining a port that the load balancer will listen too   */
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = local.http_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404"
      status_code  = "404"
    }
  }
}
/* Creating a target group for the load balancer to send traffic to, doing a health check once in awhile  */
resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = var.Port_Number
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path                = "/api/1/resolve/default?path=/service/my-service"
    port                = var.Port_Number
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 15
    matcher             = "200" # has to be HTTP 200 or fails
  }
}

/* The autoscaling-group is telling the aws_lb_target_group who is available so now we need to forward that traffic too the VMs */
resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}