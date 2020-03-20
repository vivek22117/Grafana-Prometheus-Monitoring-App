#!/usr/bin/env bash

sudo start ecs
echo ECS_CLUSTER=${healt_monitoring_cluster} >> /etc/ecs/ecs.config


echo "Install SSM-Agent"
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent