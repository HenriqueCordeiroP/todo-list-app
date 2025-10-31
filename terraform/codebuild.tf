locals {
  ecr_uri = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.app_name}"
}

resource "aws_codebuild_project" "build_push" {
  name         = "${var.app_name}-build"
  service_role = "arn:aws:iam::325583868777:role/service-role/codebuild-asn-demo-lab-service-role"
  artifacts { type = "CODEPIPELINE" }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
    environment_variable {
      name  = "ECR_URI"
      value = local.ecr_uri
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-build.yml"
  }

  cache { type = "NO_CACHE" }
  tags = { Aluno = "hcp", Aluno2 = "los2", Periodo = "8", Name = "${var.app_name}-build" }
}

resource "aws_codebuild_project" "deploy" {

  name         = "${var.app_name}-deploy"
  service_role = "arn:aws:iam::325583868777:role/service-role/codebuild-asn-demo-lab-service-role"
  artifacts { type = "CODEPIPELINE" }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
    environment_variable {
      name  = "CLUSTER_NAME"
      value = var.cluster_name
    }
    environment_variable {
      name  = "NAMESPACE"
      value = "default"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-deploy.yml"
  }
  cache { type = "NO_CACHE" }
  tags = { Aluno = "hcp", Aluno2 = "los2", Periodo = "8", Name = "${var.app_name}-deploy" }
}

resource "aws_iam_role_policy_attachment" "cb_ecr_power" {
  role       = "codebuild-asn-demo-lab-service-role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "cb_cwlogs" {
  role       = "codebuild-asn-demo-lab-service-role"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "cb_s3_full" {
  role       = "codebuild-asn-demo-lab-service-role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy" "cb_eks_describe" {
  role = "codebuild-asn-demo-lab-service-role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["eks:DescribeCluster"], Resource = "*" }
    ]
  })
}
