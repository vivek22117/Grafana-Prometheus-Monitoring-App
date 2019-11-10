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
# ECR Variables                 #
#################################
variable "enabled" {
  type = bool
  description = "True will allow to create ECR"
}

variable "repo_name" {
  type = string
  description = "ECR repository name"
}

variable "max_image_count" {
  type = number
  description = "Total number of images allowed in ECR"
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