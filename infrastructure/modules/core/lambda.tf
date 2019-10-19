data "aws_s3_bucket_object" "bucket" {
  bucket = aws_s3_bucket.bucket_artifacters.bucket
  key    = "deploy-ecs.zip"
}

resource "aws_s3_bucket" "bucket_artifacters" {
  bucket = "tech-artifacters-lambda"
  versioning {
    enabled = true
  }
}

resource "aws_lambda_function" "lambda" {
  s3_bucket         = data.aws_s3_bucket_object.bucket.bucket
  s3_key            = data.aws_s3_bucket_object.bucket.key
  s3_object_version = data.aws_s3_bucket_object.bucket.version_id
  function_name     = "deploy-ecs"
  role              = aws_iam_role.lambda_role.arn
  handler           = "deploy-ecs.handler"
  runtime           = "python3.7"
  timeout           = "60"
  memory_size       = "512"
  publish           = true
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.sns.arn
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

//Todo fix the break security in *
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
          "ecs:*"
      ],
      "Effect": "Allow",
        "Resource": "*"
    },
    {
      "Action": [
          "iam:*"
      ],
      "Effect": "Allow",
        "Resource": "*"
    }
  ]
}
EOF
}