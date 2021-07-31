resource "aws_securityhub_account" "default" {}

resource "aws_securityhub_standards_subscription" "aws_best_practices" {
  standards_arn = "arn:aws:securityhub:ap-northeast-1::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_account.default]
}

resource "aws_cloudwatch_event_rule" "securityhub" {
  name = "securityhub"

  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        "Severity" = {
          "Label" = [
            "HIGH",
            "MEDIUM",
            "CRITICAL"
          ]
        }
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "securityhub" {
  arn       = aws_sns_topic.chatbot.arn
  target_id = "securityhub"
  rule      = aws_cloudwatch_event_rule.securityhub.name
}
