#!/bin/bash

# Replace these with your actual values
CLUSTER_NAME=gaming-app
SERVICE_NAME=gaming-service
TASK_DEFINITION_NAME=./task-definition.json
CONTAINER_NAME=gamers
IMAGE_NAME=lugz
CONTAINER_PORT=80
DESIRED_COUNT=2

# Create ECS cluster
aws ecs create-cluster --cluster-name "$CLUSTER_NAME"

# Create Task Definition
 # Create Task Definition JSON
echo '{
  "family": "'$ECS_TASK_DEFINITION'",
  "containerDefinitions": [
    {
      "name": "'$CONTAINER_NAME'",
      "image": "'$ECR_REPOSITORY'",
      "portMappings": [
        {
          "containerPort": 80
        }
      ]
    }
  ]
}' > $ECS_TASK_DEFINITION

# Register ECS Task Definition
ECS_TASK_DEFINITION_ARN=$(aws ecs register-task-definition --cli-input-json file://$ECS_TASK_DEFINITION | grep "taskDefinitionArn" | cut -d'"' -f4)

# Create ECS Service
aws ecs create-service \
  --cluster "$CLUSTER_NAME" \
  --service-name "$SERVICE_NAME" \
  --task-definition "$TASK_DEFINITION_ARN" \
  --desired-count $DESIRED_COUNT \
  --launch-type EC2

echo "ECS cluster, service, and task definition created successfully!"
