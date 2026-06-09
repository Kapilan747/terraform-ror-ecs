resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "512"
  memory                   = "768"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.ecr_image_uri
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = 0
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
          name  = "DB_HOST"
          value = var.db_host
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_PORT"
          value = "3306"
        },
        {
          name  = "RAILS_MAX_THREADS"
          value = "5"
        }
      ]

      secrets = [
        {
          name      = "DB_USERNAME"
          valueFrom = var.db_username_secret_arn
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = var.db_password_secret_arn
        },
        {
          name      = "RAILS_MASTER_KEY"
          valueFrom = var.rails_master_key_secret_arn
        },
        {
          name      = "SECRET_KEY_BASE"
          valueFrom = var.secret_key_base_secret_arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.project_name
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -fsS http://localhost/up || curl -fsS http://localhost/ || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 120
      }
    }
  ])

  tags = {
    Name    = "${var.project_name}-task"
    Project = var.project_name
  }
}
