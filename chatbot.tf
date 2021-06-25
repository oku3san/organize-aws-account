data "aws_iam_policy_document" "cloudwatch_access" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
  }
}

module "chatbot_iam_role" {
  source     = "./modules/iam_role_module"
  name       = "chatbot"
  identifier = "chatbot.amazonaws.com"
  policy     = data.aws_iam_policy_document.cloudwatch_access.json
}

resource "aws_sns_topic" "chatbot" {
  name = "chatbot"
}

data "aws_iam_policy_document" "chatbot" {
  statement {
    effect    = "Allow"
    resources = [aws_sns_topic.chatbot.arn]
    actions   = ["sns:Publish"]

    principals {
      identifiers = [
        "events.amazonaws.com",
        "cloudwatch.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_sns_topic_policy" "chatbot" {
    arn    = aws_sns_topic.chatbot.arn
  policy = data.aws_iam_policy_document.chatbot.json
}

resource "aws_cloudformation_stack" "chatbot" {
  name = "chatbot"

  template_body = yamlencode({
    Description = "Managed by Terraform"
    Resources = {
      AlertNotifications = {
        Type = "AWS::Chatbot::SlackChannelConfiguration"
        Properties = {
          ConfigurationName = "AlertNotifications"
          SlackWorkspaceId  = var.slack_workspace_id
          SlackChannelId    = var.slack_channel_id
          IamRoleArn        = module.chatbot_iam_role.arn
          SnsTopicArns      = [aws_sns_topic.chatbot.arn]
        }
      }
    }
  })
}

