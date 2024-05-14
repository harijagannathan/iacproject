# Terrform Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "hari-capstone-state-bucket"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = var.region
  shared_config_files      = [var.config_file]
  shared_credentials_files = [var.credential_file]
}