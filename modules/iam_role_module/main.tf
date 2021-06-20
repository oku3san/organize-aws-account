variable "name" {}
variable "identifier" {}
variable "policy" {}

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.this.json
  name = var.name
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = [var.identifier]
      type = "Service"
    }
  }
}

resource "aws_iam_policy" "this" {
  policy = var.policy
  name = var.name
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role = aws_iam_role.this.name
}

output "arn" {
  value = aws_iam_role.this.arn
}

output "name" {
  value = aws_iam_role.this.name
}
