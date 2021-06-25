resource "aws_sns_topic" "mail" {
  name = "alert-mail"
}

data "aws_iam_policy_document" "cloudwatch_events" {
  statement {
    effect    = "Allow"
    resources = [aws_sns_topic.mail.arn]
    actions   = ["sns:Publish"]

    principals {
      identifiers = [
        "cloudwatch.amazonaws.com",
        "events.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_sns_topic_policy" "cloudwatch_events" {
  arn    = aws_sns_topic.mail.arn
  policy = data.aws_iam_policy_document.cloudwatch_events.json
}

resource "aws_sns_topic_subscription" "mail_subscription" {
  topic_arn = aws_sns_topic.mail.arn
  protocol  = "email"
  endpoint  = var.email
}
