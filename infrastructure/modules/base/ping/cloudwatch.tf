resource "aws_cloudwatch_log_metric_filter" "filter" {
  name           = "${var.name}-filter"
  pattern        = "{($.eventSource = ecr.amazonaws.com) && ($.eventName = PutImage) && ($.requestParameters.repositoryName = \"${var.name}-repository\")}"
  log_group_name = var.log

  metric_transformation {
    name      = "${var.name}-counter-basic-value"
    namespace = "LogFilterMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name                = "${var.name}-deploy"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  namespace                 = "LogFilterMetrics"
  metric_name               = "${var.name}-counter-basic-value"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "When in alarm, send message to topic ECSRepositoryECR"
  insufficient_data_actions = []
  alarm_actions             = [var.sns]
}