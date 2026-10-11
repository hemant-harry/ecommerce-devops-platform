resource "aws_appautoscaling_target" "ecs" {
	max_capacity = 3
	min_capacity = 1
	resource_id = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.app.name}"
	scalable_dimension = "ecs:service:DesiredCount"
	service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "cpu" {
	name = "${var.project_name}-${var.environment}-auto-scaling"
	policy_type = "TargetTrackingScaling"
	resource_id = aws_appautoscaling_target.ecs.resource_id
	service_namespace = aws_appautoscaling_target.ecs.service_namespace
	scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension

	target_tracking_scaling_policy_configuration {
		target_value = 80
		scale_in_cooldown = 60
		scale_out_cooldown = 60

		predefined_metric_specification {
			predefined_metric_type = "ECSServiceAverageCPUUtilization"

				}
			}
}



