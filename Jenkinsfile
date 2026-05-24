pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = 'subashree06'
        DOCKER_PASS = credentials('dockerhub-creds')
    }
    stages {
        stage('Workspace Cleanup') {
            steps { cleanWs() }
        }
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Build Docker Image') {
            steps {
                sh '''
                    set -e
                    echo "Building Docker image..."
                    BRANCH=${BRANCH_NAME}
                    if [ "$BRANCH" = "master" ]; then
                        REPO="prod"
                    else
                        REPO="dev"
                    fi
                    docker build -t $DOCKERHUB_USERNAME/$REPO:latest .
                '''
            }
        }
        stage('Docker Login & Push') {
            steps {
                sh '''
                    set -e
                    echo $DOCKER_PASS | docker login -u $DOCKERHUB_USERNAME --password-stdin
                    BRANCH=${BRANCH_NAME}
                    if [ "$BRANCH" = "master" ]; then
                        REPO="prod"
                    else
                        REPO="dev"
                    fi
                    docker push $DOCKERHUB_USERNAME/$REPO:latest
                '''
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
    }
    post {
        success { echo 'Pipeline SUCCESS ✅' }
        failure { echo 'Pipeline FAILED ❌ check logs' }
    }
}