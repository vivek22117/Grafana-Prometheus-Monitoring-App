//Global Variables
variable "profile" {
  type        = string
  description = "AWS Profile name for credentials"
}

variable "default_region" {
  type = string
  description = "AWS region to deploy our resources"
}

variable "environment" {
  type        = string
  description = "AWS Profile name for credentials"
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
  type = number
  description = "Number of days to retain cloudwatch logs"
}

variable "log_group_name" {
  type = string
  description = "Log group name for logs"
}

variable "grafana_memory" {
  type = number
  description = "Grafana memory allocation"
}

variable "grafana_cpu" {
  type = number
  description = "Grafana cpu allocation"
}

variable "prometheus_cpu" {
  type = number
  description = "Prometheus CPU allocation"
}

variable "prometheus_memory" {
  type = number
  description = "Prometheus memory allocation"
}

variable "grafana_image" {
  type = string
  description = "Grafana image from Docker"
}

variable "ecs_task_mode" {
  type = string
  description = "ECS task network mode"
}

variable "ecs_task_cpu" {
  type = number
  description = "ECS grafana task cpu allocation"
}

variable "ecs_task_memory" {
  type = number
  description = "ECS grafana task memory allocation"
}
#################################
#  Default Variables            #
#################################
variable "s3_bucket_prefix" {
  type = string
  description = "S3 deployment bucket prefix"
  default = "teamconcept-tfstate"
}


####################################
# Local variables                  #
####################################
locals {
  common_tags = {
    owner       = "Vivek"
    team        = "TeamConcept"
    environment = var.environment
  }
}