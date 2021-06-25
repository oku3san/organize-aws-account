terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45"
    }
  }

  backend "s3" {
    region = "ap-northeast-1"
    bucket = "oku3san-tfstate-bucket"
    key    = "organize-aws-account-tfstate"

    dynamodb_table = "tfstate_lock"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
