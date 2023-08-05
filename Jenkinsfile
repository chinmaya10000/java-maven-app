pipeline {
    agent any
    stages {
        stage("build") {
            steps {
                script {
                    echo "building application.."
                }
            }
        }
        stage("test") {
            steps {
                script {
                    echo "testing the application..."
                }
            }
        }
        stage("deploy") {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkions_aws_secret_access_key')
            }
            steps {
                script {
                    echo "deploying the application..."
                    sh 'kubectl create deployment nginx-deployment --image=nginx'
                }
            }
        }
    }   
}