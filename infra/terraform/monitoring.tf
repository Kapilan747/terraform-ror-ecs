resource "aws_sns_topic" "ecs_alerts" {
  name = "${var.project_name}-ecs-alerts"

  tags = {
    Name    = "${var.project_name}-ecs-alerts"
    Project = var.project_name
  }
}

resource "aws_sns_topic_subscription" "ecs_alert_email" {
  topic_arn = aws_sns_topic.ecs_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "ecs_high_cpu" {
  alarm_name          = "${var.project_name}-ecs-high-cpu"
  alarm_description   = "Alert when ECS service average CPU is greater than or equal to 20 percent"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 20
  period              = 60
  statistic           = "Average"
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.app.name
  }

  alarm_actions = [
    aws_sns_topic.ecs_alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.ecs_alerts.arn
  ]

  treat_missing_data = "notBreaching"

  tags = {
    Name    = "${var.project_name}-ecs-high-cpu"
    Project = var.project_name
  }
}
