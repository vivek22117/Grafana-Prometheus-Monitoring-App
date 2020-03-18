provider "aws" {
  region  = var.default_region
//  profile = var.profile

  version = ">=2.35"
}

provider "template" {
  version = "2.1.2"
}

provider "archive" {
  version = "1.2.2"
}

###########################################################
# Terraform configuration block is used to define backend #
# Interpolation sytanx is not allowed in Backend          #
###########################################################
terraform {
  required_version = ">=0.12"

  backend "s3" {
    profile        = "admin"
    bucket         = "doubledigit-tfstate-dev-us-east-1"
    dynamodb_table = "doubledigit-tfstate-dev-us-east-1"
    key            = "state/dev/ecr-repo/monitoring-app/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}