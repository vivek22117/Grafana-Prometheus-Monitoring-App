package com.dd.monitoring.scripts

import javaposse.jobdsl.dsl.DslFactory
import javaposse.jobdsl.dsl.Job

class MonitoringECRJobBuilder {

    DslFactory dslFactory
    String jobName
    String description
    String displayName
    String githubUrl
    String branchesName
    String credentialId
    String environment

    Job build() {
        dslFactory.pipelineJob(jobName) {
            description(description)
            displayName(displayName)

            definition {
                cpsScm {
                    scm {
                        git {
                            branches(branchesName)
                            remote {
                                url(githubUrl)
                                credentials(credentialId)
                            }
                        }
                        scriptPath('Jenkinsfile')
                        lightweight(true)
                    }
                }
            }
            label(environment)
            parameters {
                stringParam('ENVIRONMENT', environment)
            }
        }
    }
}
