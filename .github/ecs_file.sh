#!/bin/bash

# Replace these with your actual values
CLUSTER_NAME=gaming-app
SERVICE_NAME=gaming-service
TASK_DEFINITION_NAME=task-definition.json
CONTAINER_NAME=gamers
IMAGE_NAME=lugz
CONTAINER_PORT=80
DESIRED_COUNT=2

# Create ECS cluster
aws ecs create-cluster --cluster-name "$CLUSTER_NAME"

# Create Task Definition
TASK_DEFINITION=$(aws ecs create-task-definition \
  --family "$TASK_DEFINITION_NAME" \
  --container-definitions "[{\"name\": \"$CONTAINER_NAME\", \"image\": \"$IMAGE_NAME\", \"portMappings\": [{\"containerPort\": $CONTAINER_PORT}]}]"
)

# Extract Task Definition ARN
TASK_DEFINITION_ARN=$(echo "$TASK_DEFINITION" | jq -r '.taskDefinition.taskDefinitionArn')

# Create ECS Service
aws ecs create-service \
  --cluster "$CLUSTER_NAME" \
  --service-name "$SERVICE_NAME" \
  --task-definition "$TASK_DEFINITION_ARN" \
  --desired-count $DESIRED_COUNT \
  --launch-type EC2

echo "ECS cluster, service, and task definition created successfully!"
