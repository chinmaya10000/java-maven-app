#!/usr/bin/env groovy

def incrementVersion() {
    echo "Incrementing app version.."
    sh 'mvn build-helper:parse-version versions:set \
        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
        versions:commit'
    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
    def version = matcher[0][1]
    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
}

def buildJar() {
    echo "building the application for branch $BRANCH_NAME"
    sh 'mvn clean package'
}

def buildImage() {
    echo "building the docker image.."
    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        sh "docker build -t chinmayapradhan/java-maven-app:${IMAGE_NAME} ."
        sh "echo $PASS | docker login -u $USER --password-stdin"
        sh "docker push chinmayapradhan/java-maven-app:${IMAGE_NAME}"
    }
}

def deployImage() {
    echo "deploying the docker image to ec2..."
    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
    def ec2Instance = "ec2-user@3.143.254.53"
    sshagent(['ec2-server-key']) {
        sh "scp server-cmds.sh ${ec2Instance}:/home/ec2-user"
        sh "scp docker-compose.yml ${ec2Instance}:/home/ec2-user"
        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} '${shellCmd}'"
    }
}

def versionUpdate() {
    withCredentials([usernamePassword(credentialsId: 'git-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        sh 'git config --global user.email "jenkins@example.com"'
        sh 'git config --global user.name "jenkins"'

        sh "git remote set-url origin https://${USER}:${PASS}@github.com/chinmaya10000/java-maven-app.git"
        sh 'git add .'
        sh 'git commit -m "ci: version bump"'
        sh "git push origin HEAD:jenkins-jobs"
    }
}

return this

