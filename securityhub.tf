resource "aws_securityhub_account" "default" {}

resource "aws_securityhub_standards_subscription" "aws_best_practices" {
  standards_arn = "arn:aws:securityhub:ap-northeast-1::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on = [aws_securityhub_account.default]
}

resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on = [aws_securityhub_account.default]
}

resource "aws_cloudwatch_event_rule" "securityhub" {
  name = "securityhub"

  event_pattern = jsonencode({
    source = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        ProductFields = {
          "aws/securityhub/ProductName" = [
            "GuardDuty",
            "IAM Access Analyzer",
          ]
        }
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "securityhub" {
  arn = aws_sns_topic.mail.arn
  target_id = "securityhub"
  rule = aws_cloudwatch_event_rule.securityhub.name

  input_transformer {
    input_paths = {
      "description" = "$.detail.findings[0].Description"
      "severity" = "$.detail.findings[0].Severity.Label"
    }
    input_template = "\"Security Hub(<severity>) - <description>\""
  }
}
