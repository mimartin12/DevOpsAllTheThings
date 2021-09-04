# Grab the AWS Account ID
data "aws_caller_identity" "current" {}

# Create the role
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

# Create the policy to assume role
resource "aws_iam_policy" "ci_policy" {
  name        = "${var.prefix}_ci_policy"
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

# Create user
resource "aws_iam_user" "ci_user" {
  name = "${var.prefix}_user"
  path = "/"
  tags = var.tags
}

# Create the group for users
resource "aws_iam_group" "ci_users_group" {
  name = "${var.prefix}_ci_users"
}

# Assign users to newly created group
resource "aws_iam_group_membership" "ci_users_group_members" {
  name = "${var.prefix}_CI_users_group_members"
  users = [
    aws_iam_user.ci_user.name
  ]

  group = aws_iam_group.ci_users_group.name
}

# Attach policy to group
resource "aws_iam_group_policy_attachment" "ci_policy_attach" {
  group      = aws_iam_group.ci_users_group.name
  policy_arn = aws_iam_policy.ci_policy.arn
}

