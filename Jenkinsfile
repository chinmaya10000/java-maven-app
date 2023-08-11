#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
        ECR_REPO_URL = '810652276964.dkr.ecr.us-east-2.amazonaws.com'
        IMAGE_REPO = "${ECR_REPO_URL}/java-maven-app"
    }
    stages {
        stage("increment version") {
            steps {
                script {
                    echo "Increment version..."
                    sh "mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit"
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$VERSION-$BUILD_NUMBER"
                }
            }
        }
        stage("build") {
            steps {
                script {
                    echo "building application.."
                    sh 'mvn clean package'
                }
            }
        }
        stage("build and push image") {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'ecr-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t ${IMAGE_REPO}:${IMAGE_NAME} ."
                        sh "echo $PASS | docker login -u $USER --password-stdin ${ECR_REPO_URL}"
                        sh "docker push ${IMAGE_REPO}:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage("deploy") {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                APP_NAME = 'java-maven-app'
            }
            steps {
                script {
                    echo "deploying the docker image..."
                    sh 'envsubst < kubernetes/deployment.yml | kubectl apply -f -'
                    sh 'envsubst < kubernetes/service.yml | kubectl apply -f -'
                }
            }
        }
        stage("commit version update") {
            steps {
                script {
                    withCredentials([usernamePasword: 'git-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER']) {
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'
                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/chinmaya10000/java-maven-app.git"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:deploy-to-k8s'
                    }
                }
            }
        }
    }   
}