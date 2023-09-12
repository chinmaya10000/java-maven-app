pipeline {
    agent any
    stages {
        stage("copy files to ansible server") {
            steps {
                script {
                    echo "Copying all necessary files to the Ansible control node"
                    sshagent(['ansible-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* root@3.140.197.209:/root"

                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            sh 'scp $keyfile root@3.140.197.209:/root/ssh-key.pem'
                        }
                    }
                }
            }
        }
    }   
}