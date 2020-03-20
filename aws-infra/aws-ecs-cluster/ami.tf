data "aws_ami" "ecs-node-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ecs-instance-dd"]
  }
}

/*
data "aws_ami" "latest_ecs" {
  most_recent = true
  owners = [data.aws_caller_identity.current.account_id] # AWS

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}*/
