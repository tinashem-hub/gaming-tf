provider "aws" {
  region = "us-east-1"  # Replace with your preferred AWS region
}

resource "aws_ecr_repository" "gaming" {
  name = "gaming"
}

resource "aws_ecs_cluster" "gaming-cluster" {
  name = "gaming-cluster"
}

# Read the ECS task definition JSON file
data "template_file" "ecs_task_definition" {
  template = file("${path.module}/.github/workflows/task_defination.json")
}

resource "aws_ecs_task_definition" "game-app-service" {
  family                   = "game-app-service"
  network_mode             = "bridge"
  requires_compatibilities = ["FARGATE"]  # Update if using EC2 launch type

  container_definitions = file("${path.module}/.github/workflows/task_defination.json")
}

resource "aws_ecs_service" "game-app-service" {
  name            = "game-app-service"
  cluster         = aws_ecs_cluster.gaming-cluster.id
  task_definition = aws_ecs_task_definition.game-app-service.arn
  launch_type     = "FARGATE"  # Update if using EC2 launch type

  network_configuration {
    subnets = ["subnet-0340f1a6cd80d7608", "subnet-0340f1a6cd80d7608"]  # Replace with your subnet IDs
    security_groups = ["sg-07c4365745fc7f6ef"]  # Replace with your security group IDss
  }
}


