# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

# ECS Task Definition - Web
resource "aws_ecs_task_definition" "web" {
  family                   = "${var.project_name}-web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = var.app_image
      essential = true

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "true"
        },
        {
          name  = "RAILS_SERVE_STATIC_FILES"
          value = "true"
        },
        {
          name  = "DATABASE_URL"
          value = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.main.endpoint}/${var.db_name}"
        },
        {
          name  = "REDIS_URL"
        },
        {
          name  = "APP_HOST"
          value = "instagram-app-alb-591862737.ap-northeast-1.elb.amazonaws.com"
        },
        {
          name  = "AWS_REGION"
          value = var.aws_region
        },
        {
          name  = "AWS_S3_BUCKET"
          value = aws_s3_bucket.storage.bucket
        },
        {
          name  = "RAILS_MASTER_KEY"
          value = var.rails_master_key
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "web"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/up || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-web-task"
  }
}

# ECS Service - Web
resource "aws_ecs_service" "web" {
  name            = "${var.project_name}-web-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "web"
    container_port   = 3000
  }

  health_check_grace_period_seconds = 60

  depends_on = [
    aws_lb_listener.http,
  ]

  tags = {
    Name = "${var.project_name}-web-service"
  }
}

# ECS Task Definition - Sidekiq
resource "aws_ecs_task_definition" "sidekiq" {
  family                   = "${var.project_name}-sidekiq"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "sidekiq"
      image     = var.app_image
      essential = true
      command   = ["bundle", "exec", "sidekiq"]

      environment = [
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "true"
        },
        {
          name  = "DATABASE_URL"
          value = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.main.endpoint}/${var.db_name}"
        },
        {
          name  = "REDIS_URL"
        },
        {
          name  = "APP_HOST"
          value = "instagram-app-alb-591862737.ap-northeast-1.elb.amazonaws.com"
        },
        {
          name  = "AWS_REGION"
          value = var.aws_region
        },
        {
          name  = "AWS_S3_BUCKET"
          value = aws_s3_bucket.storage.bucket
        },
        {
          name  = "RAILS_MASTER_KEY"
          value = var.rails_master_key
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.sidekiq.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "sidekiq"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-sidekiq-task"
  }
}

# ECS Service - Sidekiq
resource "aws_ecs_service" "sidekiq" {
  name            = "${var.project_name}-sidekiq-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.sidekiq.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  tags = {
    Name = "${var.project_name}-sidekiq-service"
  }
}
