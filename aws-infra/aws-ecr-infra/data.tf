data "aws_iam_policy_document" "ecr_full_access" {
  statement {
    sid = "ECRFullAccess"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = var.ecr_full_access_accounts
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]
  }
}

data "aws_iam_policy_document" "ecr_readonly_access" {
  statement {
    sid = "ECRReadonlyAccess"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = var.ecr_readonly_access_accounts
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]
  }
}