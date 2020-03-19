package com.dd.monitoring

import com.dd.monitoring.builder.MonitoringECRJobBuilder
import javaposse.jobdsl.dsl.JobParent

def factory = this as JobParent
def listOfEnvironment = ["dev", "qa", "prod"]
def component = "monitoring-ecs-cluster-job"

def scriptLocation = "ecs-cluster/Jenkinsfile"
def description = "Pipeline DSL to create ECS Cluster, Load Balancer, ASG and Security groups!"
def displayName = "Monitoring ECS Cluster Builder Job"
def branchesName = "*/master"
def githubUrl = "https://github.com/vivek22117/Grafana-Prometheus-Monitoring-App.git"


new MonitoringECRJobBuilder(
        dslFactory: factory,
        description: description,
        jobName: component + "-" + listOfEnvironment.get(0),
        displayName: displayName + " " + listOfEnvironment.get(0),
        branchesName: branchesName,
        githubUrl: githubUrl,
        credentialId: 'github',
        environment: listOfEnvironment.get(0),
        scriptPath: scriptLocation
).build()


new MonitoringECRJobBuilder(
        dslFactory: factory,
        description: description,
        jobName: component + "-" + listOfEnvironment.get(1),
        displayName: displayName + " " + listOfEnvironment.get(1),
        branchesName: branchesName,
        githubUrl: githubUrl,
        credentialId: 'github',
        environment: listOfEnvironment.get(1),
        scriptPath: scriptLocation
).build()


new MonitoringECRJobBuilder(
        dslFactory: factory,
        description: description,
        jobName: component + "-" + listOfEnvironment.get(2),
        displayName: displayName + " "+ listOfEnvironment.get(2),
        branchesName: branchesName,
        githubUrl: githubUrl,
        credentialId: 'github',
        environment: listOfEnvironment.get(2),
        scriptPath: scriptLocation
).build()
