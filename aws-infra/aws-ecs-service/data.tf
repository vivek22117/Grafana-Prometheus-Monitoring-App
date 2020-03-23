###################################################
# Fetch remote state for S3 deployment bucket     #
###################################################
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    profile = var.profile
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

data "terraform_remote_state" "ecs-cluster" {
  backend = "s3"

  config = {
    profile = var.profile
    bucket = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key = "state/${var.environment}/ecs-cluster/monitoring-app/terraform.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "monitoring_ecr_state" {
  backend = "s3"

  config = {
    profile = var.profile
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/ecr-repo/monitoring-app/terraform.tfstate"
    region  = var.default_region
  }
}

data "template_file" "ecs_service_policy_template" {
  template = file("${path.module}/policy-doc/ecs-service-policy.json")
}

data "template_file" "ecs_task_policy_template" {
  template = file("${path.module}/policy-doc/ecs-task-policy.json")

  vars = {
    account_id     = data.aws_caller_identity.current.id
    environment    = var.environment
    component-name = var.component_name
  }
}

data "template_file" "grafana_prometheus_task" {
  template = file("${path.module}/tasks/grafana-task.json")

  vars = {
    grafana_image     = var.grafana_image
    log_group         = data.terraform_remote_state.ecs-cluster.outputs.ecs-cluster-log-group
    aws_region        = var.default_region
  }
}

data "aws_caller_identity" "current" {}