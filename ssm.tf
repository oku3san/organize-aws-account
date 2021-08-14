resource "aws_ssm_parameter" "slack_workspace_id" {
  name  = "/slack_workspace_id"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "slack_channel_id" {
  name  = "/slack_channel_id"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "email" {
  name  = "/email"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "domain" {
  name  = "/domain"
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "newrelic_account_id" {
  name  = "/newrelic_account_id"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "newrelic_external_id" {
  name  = "/newrelic_external_id"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "newrelic_api" {
  name  = "/newrelic_api"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "newrelic_license" {
  name  = "/NEW_RELIC_LICENSE_KEY"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}
