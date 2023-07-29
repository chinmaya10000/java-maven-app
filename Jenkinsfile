#!/usr/bin/env groovy
def gv

pipeline {

    agent any 
    tools {
        maven 'Maven'
    }
    stages {
        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    echo "building the application for branch $BRANCH_NAME"
                    sh 'mvn package'
                }
            }
        }
        stage("build and push image") {
            steps {
                script {
                    echo 'building the docker image..'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh 'docker build -t chinmayapradhan/java-maven-app:2.0 .'
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh 'docker push chinmayapradhan/java-maven-app:2.0'
                    }
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    gv.deployApp()
                }
            }
        }
    }
}