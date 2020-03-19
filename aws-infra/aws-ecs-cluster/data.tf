###################################################
# Fetch remote state for S3 deployment bucket     #
###################################################
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    profile = "admin"
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/vpc/terraform.tfstate"
    region  = var.default_region
  }
}

data "terraform_remote_state" "backend" {
  backend = "s3"

  config = {
    profile = var.profile
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/backend/terraform.tfstate"
    region  = var.default_region
  }
}

data "template_file" "ecs_instance_policy_template" {
  template = file("${path.module}/policy-doc/ecs-ec2-policy.json")
}

data "template_file" "ec2_user_data" {
  template = file("${path.module}/scripts/ec2-user-data-temp.sh")

  vars = {
    healt_monitoring_cluster = aws_ecs_cluster.monitoring_ecs_cluster.name
  }
}

data "aws_caller_identity" "current" {}