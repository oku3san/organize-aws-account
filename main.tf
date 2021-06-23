terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.45"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
