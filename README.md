# POC/ deploying images in ECS based in: 

https://medium.com/@YadavPrakshi/automate-zero-downtime-deployment-with-amazon-ecs-and-lambda-c4e49953273d

# Base of the project:

- The folder CMD contains two basic services writes in golang.
- The folder infrastructure contains the code of the infrastructure based on AWS.
    In the folder infrastructure/modules/base have the services
    In the folder infrastructure/modules/core have the basic infrastructure like an ECS cluster.
- The folder lambda contains the script for deploy ECS Fargate
- The DockerFile is the builder for services
- The Makefile has basic executions.

# Prerequisites

- Terraform ( recommended version v0.12.8 )
- Docker
- AWS Account ( recommended zone eu-west-1 )

# Map



# How to use?

# Upload the images to AWS ECR

```
    $(aws ecr get-login --no-include-email --region eu-west-1)

    docker build -t repository-helloworld .
    docker build -t repository-ping .

    docker tag repository-helloworld:latest $account.dkr.ecr.eu-west-1.amazonaws.com/repository-helloworld:latest
    docker tag repository-ping:latest $account.dkr.ecr.eu-west-1.amazonaws.com/repository-ping:latest

    docker push $account.dkr.ecr.eu-west-1.amazonaws.com/repository-helloworld:latest
    docker push $account.dkr.ecr.eu-west-1.amazonaws.com/repository-ping:latest

```

# Deploy infrastructure

```
    cd infrastructure/

    terraform init

    terraform apply
        
```

# Deploy lambda

```
    make deploy-lambda

    cd infrastructure/

    terraform apply
```

# Todo

 - CloudTrail is slow ( 15m between executions ), I need another type of event to execute the lambda.
 - The lambda code forces the deploy in the service, I think it is better the deploy in the run tasks, changing the version.