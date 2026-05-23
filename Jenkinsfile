pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = 'your-dockerhub-username'
        DOCKERHUB_PASSWORD = credentials('dockerhub-creds')
    }
    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }
        stage('Build & Push') {
            steps {
                sh './build.sh'
            }
        }
        stage('Deploy') {
            steps {
                sh "./deploy.sh ${env.BRANCH_NAME}"
            }
        }
    }
}