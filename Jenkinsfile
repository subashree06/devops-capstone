pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'subashree06'
        IMAGE_NAME = 'dev'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Build App') {
            steps {
                sh '''
                    set -e
                    echo "Installing dependencies..."
                    npm install

                    echo "Building React app..."
                    npm run build
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    set -e
                    echo "Building Docker image..."
                    docker build -t $DOCKERHUB_USERNAME/$IMAGE_NAME:latest .
                '''
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                        set -e
                        echo "Logging into DockerHub..."

                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                        echo "Pushing Docker image..."
                        docker push $DOCKER_USER/$IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    set -e

                    echo "Stopping old container (if any)..."
                    docker rm -f react-app || true

                    echo "Running new container..."
                    docker run -d --name react-app -p 80:80 $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully 🎉"
        }

        failure {
            echo "Pipeline failed ❌ check logs"
        }
    }
}