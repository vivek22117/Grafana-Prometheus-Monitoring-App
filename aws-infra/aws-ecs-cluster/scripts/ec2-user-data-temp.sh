#!/usr/bin/env bash

sudo yum install -y ecs-init
sudo systemctl start docker
sudo start ecs
echo ECS_CLUSTER=${healt_monitoring_cluster} >> /etc/ecs/ecs.config
