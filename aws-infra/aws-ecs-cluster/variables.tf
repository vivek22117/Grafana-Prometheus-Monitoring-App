//Global Variables
variable "profile" {
  type        = string
  description = "AWS Profile name for credentials"
}

variable "default_region" {
  type        = string
  description = "AWS region to deploy our resources"
}

variable "environment" {
  type        = string
  description = "Environment to be configured 'dev', 'qa', 'prod'"
}

variable "owner_team" {
  type        = string
  description = "Name of owner team"
}

variable "component_name" {
  type        = string
  description = "Component name for resources"
}


#################################
# ECS Variables                 #
#################################
variable "log_retention_days" {
  type        = number
  description = "Number of days to retain cloudwatch logs"
}

variable "bucket_name" {
  type        = string
  description = "Bucket to be accessed by ECS"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to be used for provisioning"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "max_price" {
  type        = string
  description = "Spot price for EC2 instance"
}

variable "volume_size" {
  type        = string
  description = "Volume size"
}

variable "default_target_group_port" {
  type        = number
  description = "Target group port for ECS Cluster"
}

variable "app_asg_max_size" {
  type        = string
  description = "ASG max size"
}

variable "app_asg_min_size" {
  type        = string
  description = "ASG min size"
}

variable "app_asg_desired_capacity" {
  type        = string
  description = "ASG desired capacity"
}

variable "app_asg_health_check_grace_period" {
  type        = string
  description = "ASG health check grace period"
}

variable "health_check_type" {
  type        = string
  description = "ASG health check type"
}

variable "app_asg_wait_for_elb_capacity" {
  type        = string
  description = "ASG waith for ELB capacity"
}

variable "default_cooldown" {
  type        = number
  description = "Cooldown value of ASG"
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated"
  type        = list(string)
}

variable "suspended_processes" {
  description = "The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer"
  type        = list(string)
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out"
  type        = string
}
#################################
#  Default Variables            #
#################################
variable "s3_bucket_prefix" {
  type        = string
  description = "S3 deployment bucket prefix"
  default     = "doubledigit-tfstate"
}

#####=============ASG Standards Tags===============#####
variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default = {
    owner      = "Vivek"
    team       = "DoubleDigit"
    tool       = "Terraform"
    monitoring = "true"
    Name       = "Monitoring-App"
  }
}

####################################
# Local variables                  #
####################################
locals {
  common_tags = {
    owner       = "Vivek"
    team        = "DoubleDigit"
    environment = var.environment
  }
}