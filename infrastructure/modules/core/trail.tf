data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "log" {
  name              = "trail-events"
  retention_in_days = 30
}

resource "aws_cloudtrail" "trail" {
  name                          = "trail-events"
  s3_bucket_name                = aws_s3_bucket.bucket.id
  include_global_service_events = true
  enable_logging                = true
  is_multi_region_trail         = false
  enable_log_file_validation    = false
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.log.arn
  cloud_watch_logs_role_arn     = aws_iam_role.trail_role.arn
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "trail-events-output-account"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::trail-events-output-account"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::trail-events-output-account/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role" "trail_role" {
  name = "trail-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "policy" {
  name = "cloudtrail-policy"
  role = aws_iam_role.trail_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream",
      "Effect": "Allow",
      "Action": ["logs:CreateLogStream"],
      "Resource": [
        "*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents",
      "Effect": "Allow",
      "Action": ["logs:PutLogEvents"],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
