###########################################################
#           ECS Instance Role & Policy                    #
###########################################################
resource "aws_iam_role" "ecs_instance_role" {

  name               = "MonitoringECSInstanceRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "ecs_instance_policy" {
  name        = "MonitoringECSInstanceRolePolicy"
  description = "Policy to access ECR, EC2 and Logs"
  path        = "/"
  policy      = data.template_file.ecs_instance_policy_template.rendered
}


resource "aws_iam_role_policy_attachment" "ecs_instance_role_att" {
  policy_arn = aws_iam_policy.ecs_instance_policy.arn
  role       = aws_iam_role.ecs_instance_role.name
}



###########################################################
#           ECS Service Role & Policy                     #
###########################################################
resource "aws_iam_role" "ecs_service_role" {

  name               = "MonitoringECSServiceRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs_service_policy" {
  name        = "MonitoringECSServiceRolePolicy"
  description = "Policy to access ECR, EC2 and Logs"
  path        = "/"
  policy      = data.template_file.ecs_service_policy_template.rendered
}


resource "aws_iam_role_policy_attachment" "ecs_service_role_att" {
  policy_arn = aws_iam_policy.ecs_service_policy.arn
  role       = aws_iam_role.ecs_service_role.name
}


###########################################################
#           ECS Task Role & Policy                        #
###########################################################
resource "aws_iam_role" "ecs_task_execution_role" {

  name               = "MonitoringECSTaskExecutionRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs_task_execution_role_policy" {
  name        = "MonitoringECSTaskExecutionRolePolicy"
  description = "Policy to access ECR and Logs"
  path        = "/"
  policy      = data.template_file.ecs_task_policy_template.rendered
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy_role_att" {
  policy_arn = aws_iam_policy.ecs_task_execution_role_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}



resource "aws_iam_instance_profile" "ecs_cluster_instance_profile" {
  name = "MonitoringECSClusterInstanceProfile"
  role = aws_iam_role.ecs_instance_role.name
}