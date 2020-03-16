resource "aws_cloudwatch_log_group" "monitoring_log_group" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_days

  tags = merge(local.common_tags, map("Name", "monitoring-log-group"))
}

resource "aws_ecs_cluster" "monitoring_ecs_cluster" {
  name = "${var.environment}-${var.component_name}"

  tags = merge(local.common_tags, map("Name", "monitoring-ecs-cluster"))
}

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
  depends_on = [aws_iam_role.ecs_service_role, aws_iam_role.ecs_instance_role, aws_iam_role.ecs_task_execution_role]

  name            = "${var.component_name}-ecs-service"
  iam_role        = aws_iam_role.ecs_service_role.name
  cluster         = aws_ecs_cluster.monitoring_ecs_cluster.id
  task_definition = aws_ecs_task_definition.grafana_prometheus_task_def.arn
  desired_count   = var.service_desired_count

  launch_type = var.service_launch_type

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
    container_name   = "Grafana-Container"
    container_port   = "3000"
  }
}

resource "aws_launch_template" "ecs_cluster_monitoring_app_lt" {
  name_prefix = "${var.component_name}-${var.environment}"

  image_id      = data.aws_ami.ecs-node-ami.id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(data.template_file.ec2_user_data.rendered)

  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_cluster_instance_profile.arn
  }

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price = var.max_price
    }
  }

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ecs_instance_sg.id]
    delete_on_termination       = true
  }

  placement {
    tenancy = "default"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.volume_size
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb" "ecs_monitoring_alb" {
  name = "${var.component_name}-alb"

  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnets
  internal           = "false"
  security_groups    = [aws_security_group.ecs_alb_sg.id]

  tags = {
    Name = "${var.component_name}-${var.environment}-alb"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_alb.ecs_monitoring_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
  }
}

resource "aws_alb_listener_rule" "ecs_alb_listener_rule" {
  depends_on = [aws_lb_target_group.ecs_alb_target_group]

  listener_arn = aws_lb_listener.ecs_alb_listener.arn
  priority     = "100"

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_lb_target_group" "ecs_alb_target_group" {
  name = "${var.component_name}-${var.environment}-tg"

  port        = var.target_group_port
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "instance"

  tags = {
    name = "${var.component_name}-tg"
  }

  health_check {
    enabled             = true
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
    path                = "/"
    port                = var.target_group_port
  }
}

resource "aws_autoscaling_group" "ecs_monitoring_cluster_asg" {
  name_prefix         = "ecs-monitoring-cluster-${var.environment}-asg"
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.public_subnets

  launch_template {
    id      = aws_launch_template.ecs_cluster_monitoring_app_lt.id
    version = aws_launch_template.ecs_cluster_monitoring_app_lt.latest_version
  }
  target_group_arns = [aws_lb_target_group.ecs_alb_target_group.arn]

  termination_policies      = var.termination_policies
  max_size                  = var.rsvp_asg_max_size
  min_size                  = var.rsvp_asg_min_size
  desired_capacity          = var.rsvp_asg_desired_capacity
  health_check_grace_period = var.rsvp_asg_health_check_grace_period
  health_check_type         = var.health_check_type
  wait_for_elb_capacity     = var.rsvp_asg_wait_for_elb_capacity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  default_cooldown = var.default_cooldown

  dynamic "tag" {
    for_each = var.custom_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}