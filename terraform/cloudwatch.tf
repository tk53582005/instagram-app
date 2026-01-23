# CloudWatch Log Group for ECS
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-ecs-logs"
  }
}

# CloudWatch Log Group for Sidekiq
resource "aws_cloudwatch_log_group" "sidekiq" {
  name              = "/ecs/${var.project_name}-sidekiq"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-sidekiq-logs"
  }
}