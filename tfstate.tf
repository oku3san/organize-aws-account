module "tfstate_bucket" {
  source = "./modules/s3bucket_module"
  name   = var.tfstate_bucket
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name         = "tfstate_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
