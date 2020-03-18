#!/usr/bin/env bash

echo "Install ECS Agent"
sudo yum install -y ecs-init

echo "Install Docker engine"
yum update -y
yum install docker -y
usermod -aG docker ec2-user
sudo systemctl start docker