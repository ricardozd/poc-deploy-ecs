import boto3
import json

cluster_name = 'ecs-cluster'
client = boto3.client('ecs', region_name="eu-west-1")


def get_event_name(event):
    message = event['Records'][0]['Sns']['Message']
    parsed_message = json.loads(message)
    print(parsed_message)
    print(['Records'][0]['AlarmName'])
    return parsed_message['Records'][0]['AlarmName']


def get_list_services():
    response = client.list_services(
        cluster=cluster_name,
        maxResults=99,
        launchType='FARGATE',
        schedulingStrategy='REPLICA'
    )

    return response['serviceArns']


def get_service_for_deploy(message):
    return message.split("-")[0] + "-service"


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
    if is_service_to_deploy(service_info['serviceName'], service_to_deploy):
        update_service(service_info['serviceName'], service_info['taskDefinition'])


def is_service_to_deploy(service, deploy_service):
    if service['serviceName'] == deploy_service:
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
    event_name = get_event_name(event)
    services = get_list_services()

    deploy_service = get_service_for_deploy(event_name)

    for service in services:
        service_info = get_service(service)
        for info in service_info['services']:
            deploy(info, deploy_service)
