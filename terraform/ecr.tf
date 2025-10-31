resource "aws_ecr_repository" "todo" {
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
  tags = { Aluno = "hcp", Aluno2 = "los2", Periodo = "8", Name = var.app_name }
}
