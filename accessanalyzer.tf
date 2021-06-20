resource "aws_accessanalyzer_analyzer" "default" {
  analyzer_name = "default"
}

resource "aws_cloudwatch_event_rule" "access_analyzer" {
  name = "access-analyzer"
  event_pattern = jsonencode({
    source = ["aws.access-analyzer"]
    detail-type = ["Access Analyzer Finding"]
    detail = {
      status = ["ACTIVE"]
    }
  })
}

resource "aws_cloudwatch_event_target" "access_analyzer" {
  arn = aws_sns_topic.mail.arn
  rule = aws_cloudwatch_event_rule.access_analyzer.name
  target_id = "access-analyzer"

  input_transformer {
    input_paths = {
      "type" = "$.detail.resouceType"
      "resource" = "$.detail.resource"
      "action" = "$.detail.action"
    }
    input_template = <<EOF
"<type>/<resource> allows public access."
"Action granted: <action>"
    EOF
  }
}
