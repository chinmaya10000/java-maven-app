pipeline {
    agent any
    
    tools {
        maven 'Maven'
    }

    environment {
        ANSIBLE_SERVER = "52.15.139.106"
    }

    stages {
        stage("Increment version") {
            steps {
                script {
                    echo "Increment app version..."
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    echo "Building the application.."
                    sh 'mvn clean package'
                }
            }
        }
        stage("build and push image") {
            steps {
                script {
                    echo "build and push the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t chinmayapradhan/java-maven-app:${IMAGE_NAME} ."
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push chinmayapradhan/java-maven-app:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage("copy files to ansible server") {
            steps {
                script {
                    echo "Copying all necessary files to the Ansible control node"
                    sshagent(['ansible-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* ec2-user@${ANSIBLE_SERVER}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ec2-user@${ANSIBLE_SERVER}:/home/ec2-user"

                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            script {
                                // Define the SSH command to check if the file exists on the remote server
                                sshCheckCmd = "ssh -o StrictHostKeyChecking=no ubuntu@${ANSIBLE_SERVER} 'test -e /home/ubuntu/ssh-key.pem && echo found || echo not found'"
                                // Execute the SSH command and capture the return status
                                result = sh(script: sshCheckCmd, returnStatus: true)
                                // Check the return status
                                if (result == 0) {
                                    // If the return status is 0, the file exists on the remote server
                                    echo "File already exists on the remote server. Skipping copy."
                                }
                                else {
                                    // If the return status is not 0, the file does not exist, so copy it
                                    sh "scp -o StrictHostKeyChecking=no $keyfile ubuntu@$ANSIBLE_SERVER:/home/ubuntu/ssh-key.pem"
                                }
                            }

                        }
                    }
                }
            }
        }
    }   
}