pipeline {
    agent any
    stages {
        stage("copy files to ansible server") {
            steps {
                script {
                    echo "Copying all necessary files to the Ansible control node"
                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'KEYFILE')]) {
                        sh "scp -o StrictHostKeyChecking=no -i ${KEYFILE} ansible/* chinu@18.118.119.112:/home/chinu/"
                    }
                }
            }
        }
    }   
}