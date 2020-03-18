pipeline {
    agent {
        label 'dev'
    }

    options {
        preserveStashes(buildCount: 10)
        timeout(time: 20, unit: 'MINUTES')
        skipStagesAfterUnstable()
    }
    parameters {
        string(name: 'EMAIL_TO', defaultValue: 'vivekmishra22117@gmail.com', description: 'Email Id')
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Environment....')
        choice(
            choices: ['create', 'destroy'],
            description: '',
            name: 'AWS_INFRA_ACTION')
    }
    environment {
        PATH = "${PATH}:${getTerraformPath()}"
        EMAIL_TO = 'vivekmishra22117@gmail.com'
    }

    stages {
        stage('tf-init') {
            steps {
                dir('aws-infra/aws-ecr-infra/') {
                    script {
                        sh "terraform --version"
                        sh "terraform init"
                        sh "whoami"
                    }
                }
            }
        }
        stage('tf-plan') {
            steps {
                dir('aws-infra/aws-ecr-infra/') {
                    script {
                        sh "terraform plan -var 'environment=${ENVIRONMENT}' \
                         -var-file='${ENVIRONMENT}.tfvars' -out monitoring-app-ecr-repo.tfplan; echo \$? > status"
                        def exitCode = readFile('status').trim()
                        echo "Terraform Plan Exit Code: ${exitCode}"
                        stash name: "monitoring-app-ecr-repo-plan", includes: "monitoring-app-ecr-repo.tfplan"
                    }
                }
            }
        }
        stage('tf-apply') {
            when {
                expression {
                    "${params.AWS_INFRA_ACTION}" == "create"
                }
            }
            steps {
                dir('aws-infra/aws-ecr-infra/') {
                    script {
                        def apply = false
                        try {
                            input message: 'confirm apply', ok: 'Apply config'
                            apply = true;
                        } catch (err) {
                            apply = false
                            sh "echo skipping the AWS infra creation....."
                        }
                        if (apply) {
                            sh "echo creating AWS infra....."
                            unstash "monitoring-app-ecr-repo-plan"
                            sh "terraform apply -auto-approve monitoring-app-ecr-repo.tfplan"
                        }
                    }
                }
            }
        }
        stage('build-docker') {
            when {
                expression {
                    "${params.AWS_INFRA_ACTION}" == "create"
                }
            }
            steps {
                    script {
                        echo 'Job to push Docker Image to Elastic Container Repository'
                        sh 'docker --version'
                        def AWS_ACCOUNT_ID= sh(script: "aws sts get-caller-identity --query 'Account' --output text", returnStdout: true).trim()
                        print("AWS ACCOUNT = ${AWS_ACCOUNT_ID}")

                        IMAGE_TAG=sh(script: "`date +%s`", returnStdout: true).trim()
                        echo 'Environment:' $ENVIRONMENT

                        echo 'login to ecr started'
                        //sh(script: "aws ecr get-login --no-include-email --region us-east-1", returnStdout: true)
                        //echo 'logged in successfully'

                        //echo 'Building the docker image'
                        // build a docker image
                        //sh 'docker build -t infra-monitoring-app .'
                        //echo 'Image built successfully'

                        // tag the image
                        //sh 'docker tag infra-monitoring-app:latest $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/infra-monitoring-app:$IMAGE_TAG'

                        //echo 'Pushing image to ECR'
                        // push image to ecr
                        //sh 'docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/infra-monitoring-app:$IMAGE_TAG'
                        //echo $IMAGE_TAG ' Image pushed to ECR'

                    }
            }
        }
        stage('destroy') {
            when {
                expression {
                    "${params.AWS_INFRA_ACTION}" == "destroy"
                }
            }
            steps {
                dir('aws-infra/aws-ecr-infra/') {
                    script {
                        input message: 'Destroy Plan?', ok: 'Destroy'
                        sh "echo destroying the AWS infra....."
                        sh "terraform destroy -var 'environment=${ENVIRONMENT}' -auto-approve"
                    }
                }
            }
        }
      }
      post {
             // Always runs. And it runs before any of the other post conditions.
             always {
               // Let's wipe out the workspace before we finish!
               deleteDir()
             }

             success {
              sendEmail('Successful')
             }

             failure {
              sendEmail('Failed')
             }
      }
}


def sendEmail(status) {
    mail(
            to: "$EMAIL_TO",
            subject: "Build ${env.BUILD_NUMBER} - " + status + " (${currentBuild.fullDisplayName})",
            body: """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                     <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""")
}

def getTerraformPath() {
    def tfHome = tool name: "Terraform", type: "org.jenkinsci.plugins.terraform.TerraformInstallation"
    return tfHome
}

def getChangeString() {
    MAX_MSG_LEN = 100
    def changeString = ""

    echo "Gathering SCM changes"
    def changeLogSets = currentBuild.changeSets
    for (int i = 0; i < changeLogSets.size(); i++) {
        def entries = changeLogSets[i].items
        for (int j = 0; j < entries.length; j++) {
            def entry = entries[j]
            truncated_msg = entry.msg.take(MAX_MSG_LEN)
            changeString += " - ${truncated_msg} [${entry.author}]\n"
        }
    }

    if (!changeString) {
        changeString = " - No new changes"
    }
    return changeString
}