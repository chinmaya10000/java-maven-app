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
                    gv = load "groovy.script"
                }
            }
        }
        stage("increment version") {
            steps {
                script {
                    gv.incrementVersion()
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    gv.buildJar()
                }
            }
        }
        stage("build and push image") {
            steps {
                script {
                    gv.buildImage()
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    gv.deployImage()
                }
            }
        }
        stage("commit version update") {
            steps {
                script {
                    gv.versionUpdate()
                }
            }
        }
    }
}