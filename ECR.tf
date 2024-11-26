resource "aws_ecr_repository" "api" {
  name                 = "${var.app_name}-api-ecr"

  force_delete = true
}