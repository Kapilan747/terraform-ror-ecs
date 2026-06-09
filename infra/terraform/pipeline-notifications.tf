resource "aws_sns_topic" "pipeline_alerts" {
  name = "${var.project_name}-pipeline-alerts"

  tags = {
    Name    = "${var.project_name}-pipeline-alerts"
    Project = var.project_name
  }
}

resource "aws_sns_topic_subscription" "pipeline_email" {
  topic_arn = aws_sns_topic.pipeline_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_event_rule" "codepipeline_state_change" {
  name        = "${var.project_name}-codepipeline-state-change"
  description = "Notify on Terraform RoR CodePipeline state changes"

  event_pattern = jsonencode({
    source        = ["aws.codepipeline"]
    "detail-type" = ["CodePipeline Pipeline Execution State Change"]
    detail = {
      pipeline = [aws_codepipeline.app.name]
      state    = ["SUCCEEDED", "FAILED", "CANCELED", "SUPERSEDED"]
    }
  })

  tags = {
    Name    = "${var.project_name}-codepipeline-state-change"
    Project = var.project_name
  }
}

resource "aws_cloudwatch_event_target" "codepipeline_sns" {
  rule      = aws_cloudwatch_event_rule.codepipeline_state_change.name
  target_id = "${var.project_name}-codepipeline-sns"
  arn       = aws_sns_topic.pipeline_alerts.arn
}

resource "aws_sns_topic_policy" "pipeline_alerts_policy" {
  arn = aws_sns_topic.pipeline_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEventBridgePublish"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.pipeline_alerts.arn
      }
    ]
  })
}
