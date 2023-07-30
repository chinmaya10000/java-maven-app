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
            steps {
                script {
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo "deploying docker image to EC2..."
                    def dockerComposeCmd = "docker-compose up -d"
                    sshagent(['ec2-server-key']) {
                        sh "scp docker-compose.yml ec2-user@3.143.254.53:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.143.254.53 '${dockerComposeCmd}'"
                    }
                }
            }
        }
    }   
}