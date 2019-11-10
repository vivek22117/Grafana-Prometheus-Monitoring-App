data "aws_iam_policy_document" "ecr_access_policy" {
  depends_on = [data.aws_caller_identity.current]

  count = var.enabled ? 1 : 0

  statement {
    sid    = "FullAccess"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = ["*"]
    }

    actions = [
      "*"
    ]
  }

  statement {
    sid    = "AllowPushPull"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = ["*"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
  }
}

data "aws_caller_identity" "current" {}

locals {
  common_arns = {
    user_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/JenkinsSlavesRole"
    role_arn        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/doubledigit"
  }
}