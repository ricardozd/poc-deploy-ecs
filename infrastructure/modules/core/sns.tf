resource "aws_sns_topic" "sns" {
  name = "deploy-service"
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.sns.arn
  protocol = "lambda"
  endpoint = aws_lambda_function.lambda.arn
}
