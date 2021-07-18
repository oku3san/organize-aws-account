resource "aws_sns_topic" "mail" {
  name              = "mail"
  kms_master_key_id = "alias/aws/sns"
}

data "aws_iam_policy_document" "mail" {
  statement {
    effect    = "Allow"
    resources = [aws_sns_topic.mail.arn]
    actions   = ["sns:Publish"]

    principals {
      identifiers = [
        "cloudwatch.amazonaws.com",
        "events.amazonaws.com",
        "budgets.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_sns_topic_policy" "mail" {
  arn    = aws_sns_topic.mail.arn
  policy = data.aws_iam_policy_document.mail.json
}

resource "aws_sns_topic_subscription" "mail" {
  topic_arn = aws_sns_topic.mail.arn
  protocol  = "email"
  endpoint  = aws_ssm_parameter.email.value
}
