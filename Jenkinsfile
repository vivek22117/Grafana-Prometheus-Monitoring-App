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
                        sh "terraform plan -var 'environment=${ENVIRONMENT}' -out monitoring-app-ecr-repo.tfplan; echo \$? > status"
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
                dir('/') {
                    script {
                        echo 'Job to push Docker Image to Elastic Container Repository'
                        sudo docker --version
                        IMAGE_TAG=$(date %s)
                        sh "AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)"
                        echo 'AWS Account:' $AWS_ACCOUNT_ID
                        echo 'Environment:' $ENVIRONMENT

                        echo 'login to ecr started'
                        $(aws ecr get-login --no-include-email --region us-east-1)
                        echo 'logged in successfully'

                        echo 'Building the docker image'
                        #build a docker image
                        docker build -t infra-monitoring-app .
                        echo 'Image built successfully'

                        #tag the image
                        docker tag infra-monitoring-app:latest $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/infra-monitoring-app:$IMAGE_TAG

                        echo 'Pushing image to ECR'
                        #push image to ecr
                        docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/infra-monitoring-app:$IMAGE_TAG
                        echo $IMAGE_TAG ' Image pushed to ECR'

                    }
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
            subject: "Build $BUILD_NUMBER - " + status + " (${currentBuild.fullDisplayName})",
            body: "Changes:\n " + getChangeString() + "\n\n Check console output at: $BUILD_URL/console" + "\n")
}

def getTerraformPath() {
    def tfHome = tool name: "Terraform", type: "org.jenkinsci.plugins.terraform.TerraformInstallation"
    return tfHome
}