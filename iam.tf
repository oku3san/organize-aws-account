resource "aws_iam_group" "terraform_admin" {
  name = "terraform_admin"
}

data "aws_iam_policy_document" "terraform_admin_sts_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_admin_sts_policy" {
  name   = "terraform_sts_policy"
  policy = data.aws_iam_policy_document.terraform_admin_sts_policy.json
}

resource "aws_iam_group_policy_attachment" "terraform_admin_readonly" {
  group      = aws_iam_group.terraform_admin.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "terraform_admin_stg" {
  group      = aws_iam_group.terraform_admin.name
  policy_arn = aws_iam_policy.terraform_admin_sts_policy.arn
}

resource "aws_iam_user" "terraform" {
  name          = "terraform"
  force_destroy = true
}

resource "aws_iam_group_membership" "terraform_admin" {
  group = aws_iam_group.terraform_admin.name
  name  = aws_iam_group.terraform_admin.name
  users = [aws_iam_user.terraform.name]
}

data "aws_iam_policy_document" "terraform_role_policy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform" {
  name   = "terraform_admin_policy"
  policy = data.aws_iam_policy_document.terraform_role_policy.json
}

data "aws_iam_policy_document" "terraform_role_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.terraform.name}"]
    }
  }
}

resource "aws_iam_role" "terraform" {
  name               = "terraform"
  assume_role_policy = data.aws_iam_policy_document.terraform_role_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "terraform" {
  policy_arn = aws_iam_policy.terraform.arn
  role       = aws_iam_role.terraform.name
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 12
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 0
}
