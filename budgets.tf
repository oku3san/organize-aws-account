resource "aws_budgets_budget" "monthly_cost" {
  name              = "Monthly Cost"
  budget_type       = "COST"
  limit_amount      = "10.0"
  limit_unit        = "USD"
  time_period_start = "2020-01-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator       = "GREATER_THAN"
    notification_type         = "ACTUAL"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    subscriber_sns_topic_arns = [aws_sns_topic.mail.arn]
  }
}
