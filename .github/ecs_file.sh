#!/bin/bash

# Define variables 
ECS_CLUSTER_NAME=gaming-app
ECS_SERVICE_NAME=gaming-service
ECS_TASK_DEFINITION_FILE=.github/workflows/gaming-td.json
AWS_REGION=us-east-1

# Create ECS cluster
aws ecs create-cluster --cluster-name $ECS_CLUSTER_NAME --region $AWS_REGION

# Register ECS task definition
ecs_task_definition=$(aws ecs register-task-definition --cli-input-json file://$ECS_TASK_DEFINITION_FILE --region $AWS_REGION)
task_definition_arn=$(echo $ecs_task_definition | jq -r '.taskDefinition.taskDefinitionArn')

# Create ECS service
aws ecs create-service --cluster $ECS_CLUSTER_NAME --service-name $ECS_SERVICE_NAME --task-definition $task_definition_arn --desired-count 1 --launch-type EC2 --region $AWS_REGION


