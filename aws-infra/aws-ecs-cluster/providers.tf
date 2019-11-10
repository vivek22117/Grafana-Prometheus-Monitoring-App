provider "aws" {
  region  = var.default_region
  profile = var.profile

  version = "2.35.0"
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
    profile        = "doubledigit"
    bucket         = "teamconcept-tfstate-dev-us-east-1"
    dynamodb_table = "teamconcept-tfstate-dev-us-east-1"
    key            = "state/dev/ecs-cluster/monitoring-app/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}