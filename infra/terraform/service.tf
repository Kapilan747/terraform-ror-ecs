resource "aws_ecs_service" "app" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.ecs_desired_count

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    weight            = 1
    base              = 1
  }

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 200

  health_check_grace_period_seconds = 180

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [
    aws_lb_listener_rule.app_https,
    aws_ecs_cluster_capacity_providers.main
  ]

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  tags = {
    Name    = "${var.project_name}-service"
    Project = var.project_name
  }
}
