resource "aws_ecs_service" "service" {
  name            = "${var.name}-service"
  cluster         = var.cluster_ecr_id
  task_definition = aws_ecs_task_definition.task_definition.arn

  network_configuration {
    security_groups = [
      aws_security_group.sg.id]
    subnets          = compact(split(",", var.subnets))
    assign_public_ip = true
  }

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  launch_type = "FARGATE"
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.name}-task-service"
  cpu    = 512
  memory = 1024
  requires_compatibilities = [
    "FARGATE"]
  network_mode          = "awsvpc"
  task_role_arn         = aws_iam_role.role.arn
  execution_role_arn    = aws_iam_role.role.arn
  container_definitions = <<EOF
  [
    {
      "name": "${var.name}",
      "image": "${aws_ecr_repository.ecr.repository_url}:latest",
      "cpu": 512,
      "memory": 1024,
      "networkMode": "awsvpc",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "entryPoint": [
            "/opt/app/${var.name}"
        ]
    }
  ]
  EOF
}

resource "aws_iam_role" "role" {
  name = "${var.name}-ecs-service-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
          "Service": [
                  "ecs.amazonaws.com",
                  "ecs-tasks.amazonaws.com"
                ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy" "policy" {
  name = "${var.name}-ecs-service-policy"
  role = aws_iam_role.role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "elasticloadbalancing:*",
        "ecr:*",
        "ec2:*",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}