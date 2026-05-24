pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'subashree06'
    }

    stages {

        stage('Clone') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                        set -e

                        echo "Installing dependencies..."
                        ./build.sh

                        echo "Building Docker image..."
                        docker build -t $DOCKER_USER/dev:latest .

                        echo "Logging into DockerHub..."
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                        echo "Pushing Docker image..."
                        docker push $DOCKER_USER/dev:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh "./deploy.sh ${env.BRANCH_NAME}"
            }
        }
    }
}