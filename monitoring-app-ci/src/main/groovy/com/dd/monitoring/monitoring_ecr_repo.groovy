package com.dd.monitoring

import com.dd.monitoring.builder.MonitoringECRJobBuilder
import javaposse.jobdsl.dsl.JobParent

def factory = this as JobParent
def listOfEnvironment = ["dev", "prod"]
def component = "monitoring-ecr-repo-job"

def description = "Pipeline DSL to create ECR repository and build Docker image!"
def displayName = "Monitoring ECR Repository Builder Job"
def branchesName = "*/master"
def githubUrl = "https://github.com/vivek22117/Grafana-Prometheus-Monitoring-App.git"


new MonitoringECRJobBuilder(
        dslFactory: factory,
        description: description,
        jobName: component + "-"+ listOfEnvironment.get(0),
        displayName: displayName,
        branchesName: branchesName,
        githubUrl: githubUrl,
        credentialId: 'github',
        environment: 'dev'
).build()


new MonitoringECRJobBuilder(
        dslFactory: factory,
        description: description,
        jobName: component + "-"+ listOfEnvironment.get(1),
        displayName: displayName,
        branchesName: branchesName,
        githubUrl: githubUrl,
        credentialId: 'github',
        environment: 'prod'
).build()
