pipeline {
    agent any

    stages {
        stage("test") {
            steps {
                script {
                    echo "testing the application..."
                }
            }
        }
        stage("build") {
            when {
                expression {
                    BRANCH_NAME == 'master'
                }
            }
            steps {
                script {
                    echo "building application.."
                }
            }
        }
        stage("deploy") {
            when {
                expression {
                    BRANCH_NAME == 'master'
                }
            }
            steps {
                script {
                    echo "deploying the application..."
                }
            }
        }
    } 
}