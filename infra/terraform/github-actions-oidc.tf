data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = {
    Name    = "${var.project_name}-github-actions-oidc"
    Project = var.project_name
  }
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github_actions.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }

condition {
  test     = "StringLike"
  variable = "token.actions.githubusercontent.com:sub"

  values = [
    "repo:Kapilan747/todo_app:*"
  ]
}
  }
}

resource "aws_iam_role" "github_actions_deploy_role" {
  name               = "${var.project_name}-gha-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = {
    Name    = "${var.project_name}-gha-deploy-role"
    Project = var.project_name
  }
}

data "aws_iam_policy_document" "github_actions_deploy_policy" {
  statement {
    sid    = "EcrAuth"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "EcrPush"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = [
      "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/kapilan_manual_ror_ecr"
    ]
  }

  statement {
    sid    = "EcsDeploy"
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "UploadCodePipelineSource"
    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.pipeline_artifacts.arn}/source/source.zip"
    ]
  }

  statement {
    sid    = "StartTerraformRoRCodePipeline"
    effect = "Allow"

    actions = [
      "codepipeline:StartPipelineExecution"
    ]

    resources = [
      aws_codepipeline.app.arn
    ]
  }

  statement {
    sid    = "PassEcsExecutionRole"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      aws_iam_role.ecs_task_execution_role.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "github_actions_deploy_policy" {
  name   = "${var.project_name}-gha-deploy-policy"
  policy = data.aws_iam_policy_document.github_actions_deploy_policy.json

  tags = {
    Name    = "${var.project_name}-gha-deploy-policy"
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_deploy_policy" {
  role       = aws_iam_role.github_actions_deploy_role.name
  policy_arn = aws_iam_policy.github_actions_deploy_policy.arn
}
