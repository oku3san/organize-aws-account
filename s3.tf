module "log_bucket" {
  source = "./modules/log_bucket_module"
  name   = var.log_bucket
}

resource "aws_s3_account_public_access_block" "strict" {
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
