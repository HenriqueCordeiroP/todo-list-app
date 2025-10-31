resource "aws_codestarconnections_connection" "github" {
  name          = var.codestar_connection_name
  provider_type = "GitHub"
  tags          = { Aluno = "hcp", Aluno2 = "los2", Periodo = "8", Name = var.codestar_connection_name }
}
