# Terraformとプロバイダーの設定
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # 後でS3バックエンドを設定する場合はここに追加
  # backend "s3" {
  #   bucket = "terraform-state-bucket"
  #   key    = "instagram-app/terraform.tfstate"
  #   region = "ap-northeast-1"
  # }
}

# AWSプロバイダーの設定
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "instagram-app"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# データソース: 利用可能なAZ
data "aws_availability_zones" "available" {
  state = "available"
}
