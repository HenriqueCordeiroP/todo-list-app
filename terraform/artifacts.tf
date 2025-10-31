resource "aws_s3_bucket" "artifacts" {
  bucket        = "hcp2-los2-eu-central-1-artifacts-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
  tags          = { Aluno = "hcp", Aluno2 = "los2", Periodo = "8", Name = "cicd-artifacts" }
}

data "aws_caller_identity" "current" {}
