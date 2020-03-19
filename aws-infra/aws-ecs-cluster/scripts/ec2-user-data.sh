#!/usr/bin/env bash

sudo start ecs
echo ECS_CLUSTER=${healt_monitoring_cluster} >> /etc/ecs/ecs.config


sudo yum install wget -y
INSTANCE_ID=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)

aws ec2 attach-volume --volume-id ${MonitoringDataVolume} --instance-id $INSTANCE_ID --device /dev/sdh --region ${aws_region}
IS_ATTACHED=$(aws ec2 describe-volumes --region ${aws_region} \
--filters Name=attachment.instance-id,Values=$INSTANCE_ID Name=attachment.status,Values=attached Name=size,Values=50 \
--query 'Volumes[*].Attachments[*].State' --output text)

while [[ "$IS_ATTACHED" != "attached" ]]
do
echo "Waiting volume to be attached."
sleep 20

IS_ATTACHED=$(aws ec2 describe-volumes --region ${aws_region} \
--filters Name=attachment.instance-id,Values=$INSTANCE_ID Name=attachment.status,Values=attached Name=size,Values=50 \
--query 'Volumes[*].Attachments[*].State' --output text)

done

FILESYSTEM_EXISTS=$(sudo file -s /dev/xvdh)
if [[ "$FILESYSTEM_EXISTS" == "/dev/xvdh: data" ]]; then
    sudo mkfs -t xfs /dev/xvdh
fi

sudo mkdir -p /data
sudo mount /dev/xvdh /data
sudo chown nobody:nobody /data

