pipeline {

    agent any
    tools {
        maven 'Maven'
    }
    environment {
        DOCKER_REPO_SERVER = '810652276964.dkr.ecr.us-east-2.amazonaws.com'
        DOCKER_REPO = "${DOCKER_REPO_SERVER}/java-maven-app"
    }

    stages {
        stage('build app') {
            steps {
                script {
                    echo "building the app.."
                    sh 'mvn clean package'
                }
            }
        }
        stage('build and push image') {
            steps {
                script {
                    echo "building the image.."
                    withCredentials([usernamePassword(credentialsId: 'ecr-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t ${DOCKER_REPO}:1.0 ."
                        sh "echo $PASS | docker login -u $USER --password-stdin ${DOCKER_REPO_SERVER}"
                        sh "docker push ${DOCKER_REPO}:1.0"
                    }
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    echo "deploy docker image to ec2.."
                }
            }
        }
    }
}