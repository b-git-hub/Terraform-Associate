/* Adding an output for our autoscaling group to be called in the main webservers so a schedule can be applied  */
output "asg_name" {
  value       = aws_autoscaling_group.bar.name
  description = "Autoscaling Group Name"
}

output "alb_name" {
  value       = aws_lb.lb.dns_name
  description = "Load balance name"
}