output "alb_dns_name" {
	description = "DNS Name of the Application Load Balancer"
	value = aws_lb.main.dns_name
}

output "alb_arn" {
	description = "Application Load Balancer ARN"
	value = aws_lb.main.arn
}

output "target_group_arn" {
	description = "Target Group ARN for ECS service"
	value = aws_lb_target_group.app.arn
}


