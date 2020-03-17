package com.dd.monitoring.scripts

import com.dd.monitoring.builder.MonitoringECRJobBuilder
import javaposse.jobdsl.dsl.JobParent

def factory = this as JobParent
def description = "Pipeline DSL to create ECR repository and build Docker image!"
def jobName = "monitoring-ecr-repo-job"
def displayName = "Monitoring ECR Repository Builder Job"
def branchesName = "*/master"
def githubUrl = "https://github.com/vivek22117/Grafana-Prometheus-Monitoring-App.git"


new MonitoringECRJobBuilder(
        dslFactory: factory,
        description: description,
        jobName: jobName,
        displayName: displayName,
        branchesName: branchesName,
        githubUrl: githubUrl,
        credentialId: 'github',
        environment: 'dev'
).build()


new MonitoringECRJobBuilder(
        dslFactory: factory,
        description: description,
        jobName: jobName,
        displayName: displayName,
        branchesName: branchesName,
        githubUrl: githubUrl,
        credentialId: 'github',
        environment: 'prod'
).build()
