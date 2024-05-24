pipeline {
    agent any
    
    environment {
        ANSIBLE_SERVER = "18.216.163.174"
    }

    stages {
        stage("Copy files to Ansible server") {
            steps {
                script {
                    echo "copying all neccessary files to ansible control node"
                    sshagent(['ansible-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* ec2-user@${ANSIBLE_SERVER}:/home/ec2-user"

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
        stage('Execute Ansible Playbook') {
            steps {
                script {
                    echo "calling ansible playbook to configure ec2 instances"
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