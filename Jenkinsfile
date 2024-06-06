pipeline {
    agent any

    environment {
        SLACK_CHANNEL = '#vprofile-jenkins' // Change this to your Slack channel
    }

    stages {
        stage("Build") {
            steps {
                script {
                    echo "Build app"
                }
            }
        }
        stage("test") {
            steps {
                script {
                    echo "test app"
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo "deploy app"
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