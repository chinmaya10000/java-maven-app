pipeline {

    agent any 
    tools {
        maven 'Maven'
    }
    stages {
        stage("increment version") {
            steps {
                script {
                    echo "Incrementing app version.."
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
                    echo "building the application for branch $BRANCH_NAME"
                    sh 'mvn clean package'
                }
            }
        }
        stage("build and push image") {
            steps {
                script {
                    echo "building the docker image.."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t chinmayapradhan/java-maven-app:${IMAGE_NAME} ."
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push chinmayapradhan/java-maven-app:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo "deploying the docker image to ec2..." 
                }
            }
        }
        stage("commit version update") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'git-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        
                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/chinmaya10000/java-maven-app.git"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh "git push origin HEAD:jenkins-jobs"
                    }
                }
            }
        }
    }
}