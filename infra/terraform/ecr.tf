resource "aws_ecr_repository" "app" {

  name = "kapilan_manual_ror_ecr"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "kapilan_manual_ror_ecr"
  }

}