module "cloudtrail_log_bucket" {
  source = "./modules/log_bucket_module"
  name = var.cloudtrail_log_bucket
}

data "aws_iam_policy_document" "cloudtrail_log" {
  statement {
    effect = "Allow"
    actions = ["s3:GetBucketAcl"]
    resources = [module.cloudtrail_log_bucket.arn]
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
  }

  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["${module.cloudtrail_log_bucket.arn}/*"]
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    condition {
      test = "StringEquals"
      values = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_log" {
  bucket = module.cloudtrail_log_bucket.name
  policy = data.aws_iam_policy_document.cloudtrail_log.json
  depends_on = [module.cloudtrail_log_bucket]
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "CloudTrail/logs"
  retention_in_days = 14
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    effect = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:*:log-stream:*"]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

module "cloudtrail_iam_role" {
  source = "./modules/iam_role_module"
  name = "cloudtrail"
  identifier = "cloudtrail.amazonaws.com"
  policy = data.aws_iam_policy_document.cloudtrail.json
}

resource "aws_cloudtrail" "default" {
  name = "default"
  s3_bucket_name = module.cloudtrail_log_bucket.name
  enable_logging = true
  is_multi_region_trail = true
  include_global_service_events = true
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.logs.arn}:*"
  cloud_watch_logs_role_arn = module.cloudtrail_iam_role.arn
  depends_on = [aws_s3_bucket_policy.cloudtrail_log]
}
