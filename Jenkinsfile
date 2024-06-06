pipeline {
    agent any

    environment {
        SLACK_CHANNEL = '#vprofile-jenkins'
    }
    stages {
        stage("test") {
            steps {
                script {
                    echo "testing the application..."
                }
            }
        }
        stage("build") {
            when {
                expression {
                    BRANCH_NAME == 'master'
                }
            }
            steps {
                script {
                    echo "building application.."
                }
            }
        }
        stage("deploy") {
            when {
                expression {
                    BRANCH_NAME == 'master'
                }
            }
            steps {
                script {
                    echo "deploying the application..."
                }
            }
        }
    }
    post {
        success {
            slackSend(channel: "${env.SLACK_CHANNEL}", message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL}) completed successfully.")
        }
        failure {
            slackSend(channel: "${env.SLACK_CHANNEL}", message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL}) failed.")
        }
    }   
}