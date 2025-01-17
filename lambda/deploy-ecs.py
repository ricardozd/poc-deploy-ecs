import json

import boto3

cluster_name = 'ecs-cluster'
client = boto3.client('ecs', region_name="eu-west-1")


def get_deploy_service_name(event):
    result = event['Records'][0]['Sns']['Message']
    parsed_result = json.loads(result)
    return parser_service(parsed_result['AlarmName'])


def parser_service(message):
    return message.split("-")[0] + "-service"


def get_list_services():
    response = client.list_services(
        cluster=cluster_name,
        maxResults=99,
        launchType='FARGATE',
        schedulingStrategy='REPLICA'
    )

    return response['serviceArns']


def get_service(service):
    response = client.describe_services(
        cluster=cluster_name,
        services=[
            get_name(service),
        ]
    )

    return response


def get_name(result):
    return result.split("/")[1]


def deploy(service_info, service_to_deploy):
    if is_service_to_deploy(service_info['services'][0]['serviceName'], service_to_deploy):
        update_service(service_info['services'][0]['serviceName'], service_info['services'][0]['taskDefinition'])


def is_service_to_deploy(service, deploy_service):
    if service == deploy_service:
        return True
    return False


def update_service(service_name, task_name):
    response = client.update_service(
        cluster=cluster_name,
        service=service_name,
        desiredCount=1,
        taskDefinition=task_name,
        deploymentConfiguration={
            'maximumPercent': 100,
            'minimumHealthyPercent': 0
        },
        forceNewDeployment=True
    )
    print(response)


def handler(event, lambda_context):
    service_name = get_deploy_service_name(event)
    services = get_list_services()

    for service in services:
        service_info = get_service(service)
        deploy(service_info, service_name)
