#!/usr/bin/env bash

echo "Install ECS Agent"
sudo yum install -y ecs-init

echo ECS_CLUSTER=dev-monitoring-app >> /etc/ecs/ecs.config


echo "Install SSM-Agent"
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

echo "Install Docker engine"
yum update -y
yum install docker -y
usermod -aG docker ec2-user
sudo systemctl start docker