#!/usr/bin/env groovy

@Library('jarproj-shared-library')_

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    environment {
        IMAGE_NAME = 'chinmayapradhan/java-maven-app:1.0'
    }
    stages {
        stage("build jar") {
            steps {
                script {
                    echo "building application.."
                    buildJar()
                }
            }
        }
        stage("build push image") {
            echo "buildng the docker image.."
            buildImage(env.IMAGE_NAME)
            dockerLogin()
            dockerPush(env.IMAGE_NAME)
        }
        stage("deploy") {
            steps {
                script {
                    echo "deploying docker image to EC2..."
                    def dockerCmd = 'docker run -d -p 8090:8080 ${IMAGE_NAME}'
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.145.2.34 '${dockerCmd}'"
                    }
                }
            }
        }
    }   
}