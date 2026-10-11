output "alb_security_group_id" {
	description = "ALB security group ids "
	value = aws_security_group.alb.id
}

output "ecs_security_group_id" {
	description = "ECS security group ids "
	value = aws_security_group.ecs.id
}

output "rds_security_group_id" {
	description = "RDS security group ids "
	value = aws_security_group.rds.id
}

