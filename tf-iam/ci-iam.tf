data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ci_role" {
  name = "${var.prefix}_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "${data.aws_caller_identity.current.account_id}"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "ci_policy" {
  name        = "${var.prefix}-ci_policy"
  path        = "/"
  description = "Allows user to assume ci_role."

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Resource" : "${aws_iam_role.ci_role.arn}"
        }
      ]
    }
  )

  tags = var.tags
}

resource "aws_iam_user" "ci_user" {
  name = "${var.prefix}-user"
  path = "/"
  tags = var.tags
}

resource "aws_iam_group" "ci_users_group" {
  name = "ci_users"
}

resource "aws_iam_group_membership" "ci_users_group_members" {
  name = "CI_users_group_members"
  users = [
    aws_iam_user.ci_user.name
  ]

  group = aws_iam_group.ci_users_group.name
}

resource "aws_iam_group_policy_attachment" "ci_policy_attach" {
  group      = aws_iam_group.ci_users_group.name
  policy_arn = aws_iam_policy.ci_policy.arn
}

