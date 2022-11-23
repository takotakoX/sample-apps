terraform {
  backend "s3" {
    bucket = "trading-bot-tfstate"
    key    = "sample-apps/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}