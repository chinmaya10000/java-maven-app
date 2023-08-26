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
            environment {
                DOCKER_CREDS = credentials('ecr-credentials')
            }
            steps {
                script {
                    echo "deploy docker image to ec2.."
                    
                    def shellCmd = "bash ./server-cmds.sh ${DOCKER_CREDS_USR} ${DOCKER_CREDS_PSW}"

                    sshagent(['ec2-server-key']) {
                        sh "scp server-cmds.sh ec2-user@13.58.68.31:/home/ec2-user"
                        sh "scp docker-compose.yml ec2-user@13.58.68.31:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@13.58.68.31 '${shellCmd}'"
                    }
                }
            }
        }
    }
}