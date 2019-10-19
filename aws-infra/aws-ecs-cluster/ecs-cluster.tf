resource "aws_cloudwatch_log_group" "monitoring_log_group" {
  name = var.log_group_name
  retention_in_days = var.log_retention_days

  tags = merge(local.common_tags, map("Name", "monitoring-log-group"))
}

resource "aws_ecs_cluster" "monitoring_ecs_cluster" {
  name = "${var.environment}-${var.component_name}"

  tags = merge(local.common_tags, map("Name", "monitoring-ecs-cluster"))
}

resource "aws_ecs_task_definition" "grafana_task_def" {
  container_definitions = data.template_file.grafana_task.rendered
  family = "${var.environment}_grafana"

  requires_compatibilities = ["EC2"]
  network_mode = var.ecs_task_mode
  cpu = var.grafana_cpu
  memory = var.grafana_memory
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn

  tags = merge(local.common_tags, map("Name", "Grafana-Task"))
}

resource "aws_ecs_task_definition" "prometheus_task_def" {
  container_definitions = data.template_file.prometheus_task
  family = "${var.environment}_prometheus"

  requires_compatibilities = ["EC2"]
  network_mode = var.ecs_task_mode
  cpu = var.prometheus_cpu
  memory = var.prometheus_memory
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn

  tags = merge(local.common_tags, map("Name", "Prometheus-Task"))
}