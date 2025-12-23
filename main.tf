# This tells Terraform to use AWS
provider "aws" {
  region = "us-east-1" 
}

# 1. Create the 'Storage' for your images
resource "aws_ecr_repository" "app_repo" {
  name = "my-app-repo"
  force_delete = true # This makes it easier to clean up later
}

# 2. Create the 'Neighborhood' (Cluster)
resource "aws_ecs_cluster" "main_cluster" {
  name = "my-ecs-cluster"
}

# 3. Create the 'Permissions' (IAM Role)
# This allows ECS to pull your image from the Storage (ECR)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "myEcsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# Attach the standard AWS policy to the role we just made
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}