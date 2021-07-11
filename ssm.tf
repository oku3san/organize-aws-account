resource "aws_ssm_parameter" "slack_workspace_id" {
  name  = "/slack_workspace_id"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = ["value"]
  }
}

resource "aws_ssm_parameter" "slack_channel_id" {
  name  = "/slack_channel_id"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = ["value"]
  }
}
