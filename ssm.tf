resource "aws_ssm_parameter" "slack_workspace_id" {
  name  = "/slack_workspace_id"
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "slack_channel_id" {
  name  = "/slack_channel_id"
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "email" {
  name  = "/email"
  type  = "String"
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
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "newrelic_external_id" {
  name  = "/newrelic_external_id"
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "newrelic_api" {
  name  = "/newrelic_api"
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "line_access_token" {
  name  = "/line_access_token"
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "line_channel_secret" {
  name  = "/line_channel_secret"
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "line_user_id" {
  name  = "/line_user_id"
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}
