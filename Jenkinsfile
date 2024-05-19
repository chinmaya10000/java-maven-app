pipeline {
    agent any
    
    tools {
        maven 'Maven'
    }

    environment {
        ANSIBLE_SERVER = "3.16.30.55"
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
        stage("Copy files to Ansible server") {
            steps {
                script {
                    echo "copying all neccessary files to ansible control node"
                    sshagent(['ansible-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* ec2-user@${ANSIBLE_SERVER}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ec2-user@${ANSIBLE_SERVER}:/home/ec2-user"

                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            script {
                                // Define the SSH command to check if the file exists on the remote server
                                sshCheckCmd = "ssh -o StrictHostKeyChecking=no ec2-user@${ANSIBLE_SERVER} 'if [ -e /home/ec2-user/ssh-key.pem ]; then echo found; else echo not found; fi'"
                                // Execute the SSH command and capture the output
                                result = sh(script: sshCheckCmd, returnStdout: true).trim()
                                // Check the output
                                if (result == "found") {
                                    // If the output is 'found', the file exists on the remote server
                                    echo "File already exists on the remote server. Skipping copy."
                                }
                                else {
                                    // If the output is not 'found', the file does not exist, so copy it
                                    echo "File does not exist on the remote server. Copying the PEM file."
                                    sh 'scp -o StrictHostKeyChecking=no $keyfile ec2-user@$ANSIBLE_SERVER:/home/ec2-user/ssh-key.pem'
                                }
                            }
                        }
                    }
                }
            }
        }
        stage("Execute ansible playbook") {
            steps {
                script {
                    echo "Calling ansible playbook to configure ec2 instance"
                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = ANSIBLE_SERVER
                    remote.allowAnyHosts = true

                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                        remote.user = user 
                        remote.identityFile = keyfile
                        sshCommand remote: remote, command: "ansible-playbook my-playbook.yml"
                    }
                }
            }
        }
    }   
}