#!/usr/bin/env groovy

@Library('jarproj-shared-library')

def gv

pipeline {

    agent any 
    tools {
        maven 'Maven'
    }

    environment {
        IMAGE_NAME = 'chinmayapradhan/java-maven-app:1.0'
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
                    buildJar()
                }
            }
        }
        stage("build and push image") {
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
                    gv.deployApp()
                }
            }
        }
    }
}