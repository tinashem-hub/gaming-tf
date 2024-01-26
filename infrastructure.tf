provider "aws" {
  region = "us-east-1"  # Replace with your preferred AWS region
}

resource "aws_ecr_repository" "gaming" {
  name = "gaming"
}

resource "aws_ecs_cluster" "gaming-cluster" {
  name = "gaming-cluster"
}

resource "aws_ecs_task_definition" "gaming-Td" {
  family                   = "gaming-Td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = "arn:aws:iam::954354975057:role/GitHub-demo"

  container_definitions = file("${path.module}/task_defination.json")

  # Debugging output
  dynamic "debug" {
    for_each = toset(keys(file("${path.module}/task_defination.json")))
    content {
      key   = debug.key
      value = file("${path.module}/task_defination.json")[debug.key]
    }
  }
}

resource "aws_ecs_service" "my_service" {
  name            = "game-app-service"
  cluster         = aws_ecs_cluster.gaming-cluster.id
  task_definition = aws_ecs_task_definition.gaming-Td.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = ["subnet-0340f1a6cd80d7608", "subnet-03ca82457d7c30b25"]
    security_groups = ["sg-07c4365745fc7f6ef"]
  }

  desired_count = 1
  force_new_deployment = true  # Update this value if you want to force a new deployment on updates
}

output "public_ip" {
  value = aws_ecs_service.my_service.tasks[0].network_interfaces[0].association[0].public_ip
}




