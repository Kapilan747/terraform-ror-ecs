variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
}

variable "project_name" {
  description = "Project name prefix used for Terraform-managed RoR resources"
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID where ALB, ECS, ASG, and RDS are running"
  type        = string
}

variable "existing_alb_name" {
  description = "Existing ALB name to reuse"
  type        = string
}

variable "ecr_image_uri" {
  description = "Initial ECR image URI for ECS task definition"
  type        = string
}

variable "container_name" {
  description = "Container name used in ECS task definition and imagedefinitions.json"
  type        = string
}

variable "container_port" {
  description = "Container port exposed by Nginx inside RoR container"
  type        = number
  default     = 80
}

variable "instance_type" {
  description = "EC2 instance type for ECS container instances"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum number of ECS EC2 instances"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired number of ECS EC2 instances"
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of ECS EC2 instances"
  type        = number
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
}

variable "db_host" {
  description = "RDS MySQL endpoint"
  type        = string
}

variable "db_name" {
  description = "Rails production database name"
  type        = string
}

variable "db_username_secret_arn" {
  description = "Secrets Manager ARN for DB_USERNAME"
  type        = string
}

variable "db_password_secret_arn" {
  description = "Secrets Manager ARN for DB_PASSWORD"
  type        = string
}

variable "rails_master_key_secret_arn" {
  description = "Secrets Manager ARN for RAILS_MASTER_KEY"
  type        = string
}

variable "secret_key_base_secret_arn" {
  description = "Secrets Manager ARN for SECRET_KEY_BASE"
  type        = string
}

variable "rds_security_group_id" {
  description = "Existing RDS security group ID to allow ECS access"
  type        = string
}

variable "route53_zone_name" {
  description = "Route 53 hosted zone name"
  type        = string
}

variable "domain_name" {
  description = "Terraform-managed RoR domain name"
  type        = string
}

variable "https_rule_priority" {
  description = "Unique HTTPS listener rule priority for this app"
  type        = number
}

variable "ecs_min_capacity" {
  description = "Minimum ECS service task count for Application Auto Scaling"
  type        = number
}

variable "ecs_max_capacity" {
  description = "Maximum ECS service task count for Application Auto Scaling"
  type        = number
}

variable "alert_email" {
  description = "Email address for ECS CPU alarm SNS subscription"
  type        = string
}

variable "github_owner" {
  description = "GitHub owner"
  type        = string
  default     = "Kapilan747"
}

variable "github_repo" {
  description = "GitHub app repo name"
  type        = string
  default     = "todo_app"
}

variable "github_branch" {
  description = "GitHub app branch watched by Terraform RoR pipeline"
  type        = string
}

variable "github_actions_branch" {
  description = "GitHub branch allowed to deploy through GitHub Actions OIDC"
  type        = string
  default     = "terraform-ecs"
}

variable "pipeline_alert_email" {
  description = "Email address for deployment status notifications"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for ECS EC2 Auto Scaling Group"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID attached to the existing ALB"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name for ECS container instances"
  type        = string
}
