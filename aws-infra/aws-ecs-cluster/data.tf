###################################################
# Fetch remote state for S3 deployment bucket     #
###################################################

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    profile = "doubledigit"
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/vpc/terraform.tfstate"
    region  = var.default_region
  }
}


data "terraform_remote_state" "backend" {
  backend = "s3"

  config = {
    profile = var.profile
    bucket = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key = "state/${var.environment}/aws/terraform.tfstate"
    region = var.default_region
  }
}

data "template_file" "ecs_instance_policy_template" {
  template = file("${path.module}/policy-doc/ecs-ec2-policy.json")

  vars {
    bucket_name = var.bucket_name
  }
}

data "template_file" "ec2_user_data" {
  template = file("${path.module}/scripts/ec2-user-data.sh")

  vars = {
    healt_monitoring_cluster = aws_ecs_cluster.monitoring_ecs_cluster.name
  }
}

data "template_file" "ecs_service_policy_template" {
  template = file("${path.module}/policy-doc/ecs-service-policy.json")
}

data "template_file" "ecs_task_policy_template" {
  template = file("${path.module}/policy-doc/ecs-task-policy.json")

  vars {
    account_id = data.aws_caller_identity.current.id
    environment = var.environment
    component-name = var.component_name
  }
}


data "terraform_remote_state" "monitoring_ecr_state" {
  backend = "s3"

  config = {
    profile = var.profile
    bucket = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key = "state/${var.environment}/ecr-repo/monitoring-app/terraform.tfstate"
    region = var.default_region
  }
}

data "template_file" "grafana_task" {
  template = file("${path.module}/tasks/grafana-task.json")

  vars {
    image = var.grafana_image
    log_group = aws_cloudwatch_log_group.monitoring_log_group.name
    aws_region = var.default_region
    memory = var.grafana_memory
  }
}

data "template_file" "prometheus_task" {
  template = file("${path.module}/tasks/prometheus-task.json")

  vars {
    image = data.terraform_remote_state.monitoring_ecr_state.outputs.ecr_repository_url
    log_group = aws_cloudwatch_log_group.monitoring_log_group.name
    aws_region = var.default_region
    memory = var.prometheus_memory
  }
}

data "aws_caller_identity" "current" {}