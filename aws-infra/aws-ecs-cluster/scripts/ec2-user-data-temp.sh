#!/usr/bin/env bash

sudo start ecs
echo ECS_CLUSTER=${healt_monitoring_cluster} >> /etc/ecs/ecs.config
