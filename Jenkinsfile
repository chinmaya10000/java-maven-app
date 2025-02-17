pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    environment {
        ECR_REPO_URL = '156041433917.dkr.ecr.us-east-2.amazonaws.com'
        deploymentName = "java-app"
        containerName = "java-app"
        serviceName = "java-app"
        imageName = "${ECR_REPO_URL}/my-app:${GIT_COMMIT}"
        AWS_REGION = 'us-east-2'
        SCANNER_HOME = tool 'sonar-scanner'
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo 'Checking out code from repository...'
                    checkout scm
                }
            }
        }
        stage('Compile') {
            steps {
                script {
                    echo 'compile the application ...'
                    sh 'mvn compile'
                }
            }
        }
        stage('Tests') {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    echo "Running SonarQube analysis..."
                    withSonarQubeEnv('sonar-server') {
                        sh "mvn sonar:sonar -Dsonar.projectKey=java-maven-app -Dsonar.projectName='java-maven-app'"
                    }
                }
            }
        }
        stage('Building the App') {
            steps {
                script {
                    sh 'mvn package -DskipTests=True'
                }
            }
        }
        stage('Build and Push Image') {
            steps {
                script {
                    sh "docker build -t ${imageName} ."
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URL}"
                    sh "docker push ${imageName}"
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                parallel(
                    "Deployment": {
                        withKubeConfig(caCertificate: '', clusterName: 'dev-myapp-eks', contextName: '', credentialsId: 'k8s-creds', namespace: 'my-app', restrictKubeConfigAccess: false, serverUrl: 'https://CD2066F36330BA16FD242C270FE14CC0.gr7.us-east-2.eks.amazonaws.com') {
                            sh "bash k8s-deployment.sh" 
                        }
                    },
                    "Rollout Status": {
                        withKubeConfig(caCertificate: '', clusterName: 'dev-myapp-eks', contextName: '', credentialsId: 'k8s-creds', namespace: 'my-app', restrictKubeConfigAccess: false, serverUrl: 'https://CD2066F36330BA16FD242C270FE14CC0.gr7.us-east-2.eks.amazonaws.com') {
                            sh "bash k8s-deployment-rollout-statu.sh" 
                        }
                    }
                )
            }
        }
    }
}