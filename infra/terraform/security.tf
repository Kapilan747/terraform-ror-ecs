resource "aws_security_group" "ecs_instance_sg" {
  name        = "${var.project_name}-ecs-instance-sg"
  description = "Security group for Terraform RoR ECS EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ECS dynamic ports from ALB"
    from_port       = 32768
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-ecs-instance-sg"
    Project = var.project_name
  }
}

resource "aws_security_group_rule" "rds_mysql_from_ecs_instances" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = var.rds_security_group_id
  source_security_group_id = aws_security_group.ecs_instance_sg.id
  description              = "Allow MySQL from Terraform RoR ECS instances"
}
