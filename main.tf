terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.45"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region = "ap-northeast-1"
}
