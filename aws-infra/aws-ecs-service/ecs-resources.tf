resource "aws_ecs_task_definition" "grafana_prometheus_task_def" {
  container_definitions = data.template_file.grafana_prometheus_task.rendered
  family                = "${var.environment}_grafana_prometheus"

  requires_compatibilities = ["EC2"]
  network_mode             = var.ecs_task_mode
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  tags = merge(local.common_tags, map("Name", "Prometheus-Grafana-Task"))
}