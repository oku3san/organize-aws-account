data "aws_iam_policy_document" "newrelic_role_assume_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    condition {
      test     = "StringEquals"
      values   = [aws_ssm_parameter.newrelic_external_id.value]
      variable = "sts:ExternalId"
    }
    effect = "Allow"
    principals {
      identifiers = [aws_ssm_parameter.newrelic_account_id.value]
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "newrelic" {
  assume_role_policy = data.aws_iam_policy_document.newrelic_role_assume_policy.json
  name               = "newrelic"
}

resource "aws_iam_role_policy_attachment" "newrelic_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.newrelic.name
}

data "aws_iam_policy_document" "newrelic_role_policy" {
  statement {
    actions = [
      "budgets:ViewBudget"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "newrelic_role_policy" {
  name   = "newrelic_role_policy"
  policy = data.aws_iam_policy_document.newrelic_role_policy.json
}

resource "aws_iam_role_policy_attachment" "newrelic_role_policy" {
  policy_arn = aws_iam_policy.newrelic_role_policy.arn
  role       = aws_iam_role.newrelic.name
}

module "newrelic_firehose_bucket" {
  source = "./modules/s3bucket_module"
  name   = var.newrelic_firehose_bucket
}

data "aws_iam_policy_document" "newrelic_firehose" {
  statement {
    effect = "Allow"
    resources = [
      module.newrelic_firehose_bucket.arn,
      "${module.newrelic_firehose_bucket.arn}/*"
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
  }
}

module "firehose_newrelic_iam_role" {
  source     = "./modules/iam_role_module"
  name       = "newrelic-firehose"
  identifier = "firehose.amazonaws.com"
  policy     = data.aws_iam_policy_document.newrelic_firehose.json
}

resource "aws_kinesis_firehose_delivery_stream" "newrelic" {
  name        = "newrelic-metric-stream"
  destination = "http_endpoint"

  http_endpoint_configuration {
    buffering_interval = "60"
    buffering_size     = "1"
    cloudwatch_logging_options {
      enabled = "false"
    }
    name = "New Relic"
    request_configuration {
      content_encoding = "GZIP"
    }
    retry_duration = "60"
    role_arn       = module.firehose_newrelic_iam_role.arn
    s3_backup_mode = "FailedDataOnly"
    url            = "https://aws-api.newrelic.com/cloudwatch-metrics/v1"
    access_key     = aws_ssm_parameter.newrelic_api.value
  }

  s3_configuration {
    bucket_arn      = module.newrelic_firehose_bucket.arn
    buffer_interval = "300"
    buffer_size     = "5"
    cloudwatch_logging_options {
      enabled = "false"
    }
    compression_format = "GZIP"
    role_arn           = module.firehose_newrelic_iam_role.arn
  }

  server_side_encryption {
    enabled  = "true"
    key_type = "AWS_OWNED_CMK"
  }
}

data "aws_iam_policy_document" "newrelic_cloudwatch_stream" {
  statement {
    effect = "Allow"
    resources = [
      aws_kinesis_firehose_delivery_stream.newrelic.id
    ]

    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
  }
}

module "cloudwatch_metrics_stream_newrelic_iam_role" {
  source     = "./modules/iam_role_module"
  name       = "newrelic-cloudwatch-metrics-stream"
  identifier = "streams.metrics.cloudwatch.amazonaws.com"
  policy     = data.aws_iam_policy_document.newrelic_cloudwatch_stream.json
}

#resource "aws_cloudwatch_metric_stream" "newrelic" {
#  name          = "newrelic-metric-stream"
#  role_arn      = module.cloudwatch_metrics_stream_newrelic_iam_role.arn
#  firehose_arn  = aws_kinesis_firehose_delivery_stream.newrelic.id
#  output_format = "opentelemetry0.7"
#}
