output "ecs-cluster-log-group" {
  value = aws_cloudwatch_log_group.monitoring_log_group.name
  description = "AWS cloud-watch log group name"
}

output "ecs-clustser-name" {
  value = aws_ecs_cluster.monitoring_ecs_cluster.name
  description = "AWS ECS Monitoring cluster name"
}

output "ecs-cluster-lb-arn" {
  value = aws_alb.ecs_monitoring_alb.arn
  description = "ECS cluster load balancer ARN!"
}

output "ecs-cluster-id" {
  value = aws_ecs_cluster.monitoring_ecs_cluster.id
  description = "AWS Monitoring app ECS Cluster id!"
}

output "alb-target-group-arn" {
  value = aws_lb_target_group.ecs_alb_default_target_group.arn
}