# Role do CodePipeline
data "aws_iam_policy_document" "codepipeline_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "codepipeline" {
  name               = "${var.app_name}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume.json
  tags               = { Aluno = "hcp", Aluno2 = "los2", Periodo = "8", Name = "${var.app_name}-codepipeline-role" }
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:GetObjectVersion", "s3:PutObject", "s3:PutObjectAcl", "s3:ListBucket"]
    resources = [aws_s3_bucket.artifacts.arn, "${aws_s3_bucket.artifacts.arn}/*"]
  }
  statement {
    actions   = ["codebuild:BatchGetBuilds", "codebuild:StartBuild", "codebuild:BatchGetProjects"]
    resources = [aws_codebuild_project.build_push.arn, aws_codebuild_project.deploy.arn]
  }
  statement {
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.github.arn]
  }
}
resource "aws_iam_role_policy" "codepipeline_inline" {
  role   = aws_iam_role.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

resource "aws_codepipeline" "this" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.artifacts.bucket
  }

  stage {
    name = "Source"
    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceOutput"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "${var.github_owner}/${var.github_repo}"
        BranchName       = var.github_branch
        DetectChanges    = "true"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build_and_Push_ECR"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.build_push.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy_to_EKS"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceOutput", "BuildOutput"]
      version         = "1"
      configuration = {
        ProjectName   = aws_codebuild_project.deploy.name
        PrimarySource = "SourceOutput"
      }
    }
  }

  tags = { Aluno = "hcp", Aluno2 = "los2", Periodo = "8", Name = var.pipeline_name }
}
