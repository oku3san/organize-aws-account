data "aws_iam_policy_document" "terraform_admin_access" {
  statement {
    effect = "Allow"
    actions = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_admin_access" {
  name = "terraform_admin_access"
  policy = data.aws_iam_policy_document.terraform_admin_access.json
}

resource "aws_iam_user" "terraform" {
  name = "terraform"
  force_destroy = true
}

resource "aws_iam_group" "terraform_admin" {
  name = "terraform_admin"
}

resource "aws_iam_group_membership" "terraform_admin" {
  group = aws_iam_group.terraform_admin.name
  name = aws_iam_group.terraform_admin.name
  users = [aws_iam_user.terraform.name]
}

resource "aws_iam_group_policy_attachment" "terraform_admin" {
  group = aws_iam_group.terraform_admin.name
  policy_arn = aws_iam_policy.terraform_admin_access.arn
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length = 12
  require_uppercase_characters = true
  require_lowercase_characters = true
  require_numbers = true
  require_symbols = true
  allow_users_to_change_password = true
  max_password_age = 0
}
