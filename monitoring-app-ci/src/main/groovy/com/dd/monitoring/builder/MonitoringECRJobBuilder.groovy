package com.dd.monitoring.builder

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
    String scriptPath


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
                        scriptPath(scriptPath)
                        lightweight(true)
                    }
                }
            }
            parameters {
                stringParam('ENVIRONMENT', environment)
                nodeParam(environment) {
                    description('Select the node to execute the job!')
                    defaultNodes(['dev'])
                }
            }
        }
    }
}
