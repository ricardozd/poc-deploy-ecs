output "cluster_ecs_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "log_name" {
  value = aws_cloudwatch_log_group.log.name
}

output "sns_arn" {
  value = aws_sns_topic.sns.arn
}