owner_team     = "DoubleDigit"
default_region = "us-east-1"

component_name = "monitoring-app"

log_group_name     = "ecs-cluster-monitoring-app"
log_retention_days = 3
grafana_image      = "grafana/grafana"

instance_type                      = "t2.small"
key_name                           = "doubledigit-solutions"
max_price                          = "0.0090"
volume_size                        = "10"
target_group_port                  = 3000
rsvp_asg_max_size                  = "3"
rsvp_asg_min_size                  = "2"
rsvp_asg_desired_capacity          = "2"
health_check_type                  = "ELB"
rsvp_asg_health_check_grace_period = "240"
rsvp_asg_wait_for_elb_capacity     = "1"
default_cooldown                   = 300
termination_policies               = ["OldestInstance", "Default"]
suspended_processes                = []
wait_for_capacity_timeout          = "7m"
bucket_name                        = "doubledigit-tfstate-dev-us-east-1"

ecs_task_mode     = "bridge"

service_desired_count = 2
service_launch_type = "EC2"
