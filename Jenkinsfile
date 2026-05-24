pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'subashree06'
        IMAGE_NAME = 'dev'
        IMAGE_TAG = 'latest'
    }

    stages {

        stage('Workspace Cleanup') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    set -e
                    echo "Installing dependencies..."
                    npm install
                '''
            }
        }

        stage('Build React App') {
            steps {
                sh '''
                    set -e
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
                    docker build -t $DOCKERHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG .
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
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
        sh '''
            set -e
            echo "Stopping old container..."
            docker stop dev-app || true
            docker rm dev-app || true
            echo "Running new container..."
            docker run -d --name dev-app -p 80:80 subashree06/dev:latest
            echo "Deployment complete!"
                '''
            }
        }

        stage('Cleanup Docker') {
            steps {
                sh '''
                    docker system prune -af || true
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline SUCCESS ✅"
        }
        failure {
            echo "Pipeline FAILED ❌ check logs"
        }
    }
}