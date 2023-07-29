#!/usr/bin/env groovy

@Library('jarproj-shared-library')
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
                    buildJar()
                }
            }
        }
        stage("build and push image") {
            steps {
                script {
                    buildImage('chinmayapradhan/java-maven-app:2.0')
                    dockerLogin()
                    dockerPush('chinmayapradhan/java-maven-app:2.0')
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