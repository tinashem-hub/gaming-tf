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
  family                   = "gaming-Td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu                      = 256  # Specify the CPU at the task level
  memory                   = 512  # Adjust memory as needed

  container_definitions = jsonencode([
    {
      "name"            = "gaming",
      "image"           = "954354975057.dkr.ecr.us-east-1.amazonaws.com/gaming",
      "cpu"             = 0,  # Remove this line from the container definition
      "memory"          = 512,
      "portMappings"    = [
        {
          "name"          = "gaming-80-tcp",
          "containerPort" = 80,
          "hostPort"      = 80,
          "protocol"      = "tcp",
          "appProtocol"   = "http",
        },
      ],
      "essential"       = true,
      "environment"     = [],
      "environmentFiles" = [],
      "mountPoints"     = [],
      "volumesFrom"     = [],
      "ulimits"         = [],
      "logConfiguration" = {
        "logDriver" = "awslogs",
        "options"   = {
          "awslogs-create-group"       = "true",
          "awslogs-group"              = "/ecs/gaming-Td",
          "awslogs-region"             = "us-east-1",
          "awslogs-stream-prefix"      = "ecs",
        },
        "secretOptions" = [],
      },
    },
  ])

  # Additional attributes (if needed)
  execution_role_arn = "arn:aws:iam::954354975057:role/GitHub-demo"
  task_role_arn      = "arn:aws:iam::954354975057:role/GitHub-demo"
  tags               = {}  # Add tags as needed
}


resource "aws_ecs_service" "game-app-service" {
  name            = "game-app-service"
  cluster         = aws_ecs_cluster.gaming-cluster.id
  task_definition = aws_ecs_task_definition.game-app-service.arn
  launch_type     = "FARGATE"  # Update if using EC2 launch type

  network_configuration {
    subnets = ["subnet-0340f1a6cd80d7608", "subnet-0340f1a6cd80d7608"]  # Replace with your subnet IDs
    security_groups = ["sg-07c4365745fc7f6ef"]  # Replace with your security group IDs
  }
}


