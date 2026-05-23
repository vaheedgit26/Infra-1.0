# GitHub Runner IRSA Role
data "aws_iam_policy_document" "github_runner_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:github-runner:github-runner"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [var.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "github_runner_role" {
  name               = "${var.project}-${var.env}-github-runner-role"
  assume_role_policy = data.aws_iam_policy_document.github_runner_assume_role.json

  tags = {
    Name    = "${var.project}-${var.env}-github-runner-role"
    Env     = var.env
    Project = var.project
  }
}

resource "aws_iam_policy" "github_runner_policy" {
  name        = "${var.project}-${var.env}-github-runner-policy"
  description = "Allow GitHub Runner to push to ECR and describe EKS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_runner_policy_attachment" {
  role       = aws_iam_role.github_runner_role.name
  policy_arn = aws_iam_policy.github_runner_policy.arn
}
