/* Setting my scaling group to deploy */
resource "aws_autoscaling_group" "bar" {
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = data.aws_subnet_ids.private.ids
  launch_configuration = aws_launch_configuration.example.name
  /* Setting the autoscaling group to speak too the load balancer so the load balancer how many VMs are available  */
  target_group_arns = [aws_lb_target_group.test.arn]
  health_check_type = "ELB"
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-AutoScale"
    propagate_at_launch = true
  }
}