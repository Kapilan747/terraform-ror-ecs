resource "aws_secretsmanager_secret" "rails_master_key" {
  name = "${var.project_name}/rails-master-key"

  tags = {
    Name = "${var.project_name}-rails-master-key"
  }
}


resource "aws_secretsmanager_secret" "secret_key_base" {
  name = "${var.project_name}/secret-key-base"

  tags = {
    Name = "${var.project_name}-secret-key-base"
  }
}

resource "aws_secretsmanager_secret_version" "rails_master_key" {

  secret_id = aws_secretsmanager_secret.rails_master_key.id

  secret_string = var.rails_master_key
}


resource "aws_secretsmanager_secret_version" "secret_key_base" {

  secret_id = aws_secretsmanager_secret.secret_key_base.id

  secret_string = var.secret_key_base
}