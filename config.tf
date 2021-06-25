module "config_log_bucket" {
  source = "./modules/log_bucket_module"
  name   = var.config_log_bucket
}

data "aws_iam_policy_document" "config_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [module.config_log_bucket.arn]
    principals {
      identifiers = ["config.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${module.config_log_bucket.arn}/AWSLogs/*/Config/*"]
    principals {
      identifiers = ["config.amazonaws.com"]
      type        = "Service"
    }
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }
}

resource "aws_s3_bucket_policy" "config_log" {
  bucket     = module.config_log_bucket.name
  policy     = data.aws_iam_policy_document.config_log.json
  depends_on = [module.config_log_bucket]
}

resource "aws_iam_service_linked_role" "config" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_config_configuration_recorder" "default" {
  name     = "default"
  role_arn = aws_iam_service_linked_role.config.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "default" {
  name           = aws_config_configuration_recorder.default.name
  s3_bucket_name = module.config_log_bucket.name
  depends_on     = [aws_config_configuration_recorder.default]
}

resource "aws_config_configuration_recorder_status" "default" {
  name       = aws_config_configuration_recorder.default.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.default]
}
