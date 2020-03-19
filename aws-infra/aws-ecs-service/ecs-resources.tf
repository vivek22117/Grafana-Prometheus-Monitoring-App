resource "aws_ecs_task_definition" "grafana_prometheus_task_def" {
  container_definitions = data.template_file.grafana_prometheus_task.rendered
  family                = "${var.environment}_grafana_prometheus"

  requires_compatibilities = ["EC2"]
  network_mode             = var.ecs_task_mode
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  tags = merge(local.common_tags, map("Name", "Prometheus-Grafana-Task"))
}


resource "aws_ecs_service" "monitoring_ecs_service" {
  depends_on = [aws_iam_role.ecs_service_role, aws_iam_role.ecs_task_execution_role]

  name            = "${var.component_name}-ecs-service"
  iam_role        = aws_iam_role.ecs_service_role.name
  cluster         = data.terraform_remote_state.ecs-cluster.outputs.ecs-cluster-id
  task_definition = aws_ecs_task_definition.grafana_prometheus_task_def.arn
  desired_count   = var.service_desired_count
  scheduling_strategy = "REPLICA"

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 70

  launch_type = var.service_launch_type

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
    container_name   = "Grafana-Container"
    container_port   = 3000
  }
}