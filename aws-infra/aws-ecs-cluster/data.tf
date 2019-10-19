###################################################
# Fetch remote state for S3 deployment bucket     #
###################################################
data "terraform_remote_state" "backend" {
  backend = "s3"

  config = {
    profile = var.profile
    bucket ="${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key = "state/${var.environment}/aws/terraform.tfstate"
    region = var.default_region
  }
}


data "terraform_remote_state" "monitoring_ecr_state" {
  backend = "s3"

  config = {
    profile = var.profile
    bucket ="${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key = "state/${var.environment}/ecr-repo/monitoring-app/terraform.tfstate"
    region = var.default_region
  }
}

data "template_file" "grafana_task" {
  template = file("${path.module}/tasks/grafana-task.json")

  vars {
    image           = var.grafana_image
    log_group       = aws_cloudwatch_log_group.monitoring_log_group.name
    aws_region      = var.default_region
    memory          = var.grafana_memory
  }
}

data "template_file" "prometheus_task" {
  template = file("${path.module}/tasks/prometheus-task.json")

  vars {
    image           = data.terraform_remote_state.monitoring_ecr_state.outputs.ecr_repository_url
    log_group       = aws_cloudwatch_log_group.monitoring_log_group.name
    aws_region      = var.default_region
    memory          = var.prometheus_memory
  }
}