#!/usr/bin/env bash

sudo yum install -y
ecs-init
sudo service docker start
sudo start ecs
echo ECS_CLUSTER=${healt_monitoring_cluster} >> /etc/ecs/ecs.config