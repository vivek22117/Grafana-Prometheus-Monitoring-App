pipeline {
    agent any

    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "Terraform"
    }

    options {
        preserveStashes(buildCount: 5)
        timeout(time: 20, unit: 'MINUTES')
        skipStagesAfterUnstable()
    }
    parameters {
        string(name: 'EMAIL_TO', defaultValue: 'vivekmishra22117@gmail.com', description: 'Email Id')
    }
    environment {
        TF_HOME = tool('Terraform')
        TF_IN_AUTOMATION = "true"
        PATH = "$TF_HOME:$PATH"
        AWS_METADATA_URL = "http://169.254.169.254:80/latest"
        AWS_METADATA_ENDPOINT = "http://169.254.169.254:80/latest"
        AWS_METADATA_TIMEOUT = "2s"
        EMAIL_TO = 'vivekmishra22117@gmail.com'
        POM_VERSION = readMavenPom().getVersion()
        BUILD_RELEASE_VERSION = readMavenPom().getVersion().replace("-SNAPSHOT", "")
        IS_SNAPSHOT = readMavenPom().getVersion().endsWith("-SNAPSHOT")
        GIT_TAG_COMMIT = sh(script: 'git describe --tags --always', returnStdout: true).trim()
    }

    stages {
        stage('build-docker') {
            steps {
                dir('/') {
                    script {
                        echo 'Job to push Docker Image to Elastic Container Repository'
                        sudo docker --version
                        echo 'login to ecr started'

                    }
                }
            }
        }
        stage('tf-init') {
            steps {
                dir('aws-infra/lambda-fixed-resources/') {
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
                dir('aws-infra/lambda-fixed-resources/') {
                    script {
                        sh "terraform plan -out rsvp-lambda-processor.tfplan; echo \$? > status"
                        def exitCode = readFile('status').trim()
                        echo "Terraform Plan Exit Code: ${exitCode}"
                        stash name: "rsvp-lambda-processor-plan", includes: "rsvp-lambda-processor.tfplan"
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