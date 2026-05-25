# 🚀 DevOps Application Deployment Capstone

> A production-ready deployment pipeline for a React application using Docker, Jenkins CI/CD, AWS EC2, and open-source monitoring.

**Author:** Subashree  
**GitHub:** [subashree06](https://github.com/subashree06)  
*Capstone Project — DevOps Application Deployment | GUVI × HCL*

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Phase 1 - Application Setup](#-phase-1---application-setup)
- [Phase 2 - Docker](#-phase-2---docker)
- [Phase 3 - Bash Scripts](#-phase-3---bash-scripts)
- [Phase 4 - Version Control](#-phase-4---version-control)
- [Phase 5 - Docker Hub](#-phase-5---docker-hub)
- [Phase 6 - Jenkins CI/CD](#-phase-6---jenkins-cicd)
- [Phase 7 - AWS Deployment](#-phase-7---aws-deployment)
- [Phase 8 - Monitoring](#-phase-8---monitoring)
- [Submission](#-submission)

---

## 📌 Project Overview

This project demonstrates a complete DevOps workflow — from source code to a live, production-ready React application deployed on AWS EC2. The pipeline automates building and deploying Docker images using Jenkins, triggered by GitHub branch activity.

**Source Repository:** [https://github.com/sriram-R-krishnan/devops-build](https://github.com/sriram-R-krishnan/devops-build)

---

## 🛠 Tech Stack

| Tool | Purpose |
|------|---------|
| React | Frontend Application |
| Docker | Containerization |
| Docker Compose | Multi-container orchestration |
| Bash | Automation scripts |
| Git & GitHub | Version control |
| Docker Hub | Container registry |
| Jenkins | CI/CD pipeline |
| AWS EC2 (t2.micro) | Cloud deployment |
| Uptime Kuma | Open-source monitoring |

---

## 📁 Project Structure

```
devops-capstone/
├── screenshots/
├── build/
├── Dockerfile
├── docker-compose.yml
├── Jenkinsfile
├── build.sh
├── deploy.sh
├── .gitignore
├── .dockerignore
└── README.md
```

---

## 🖥 Phase 1 - Application Setup

Clone the source repository and run the React application locally on port 80.

### Clone the repo
```bash
git clone https://github.com/sriram-R-krishnan/devops-build
cd devops-build
```

### Run locally on Windows (port 80)
```powershell
cd C:\Users\Administrator\devops-capstone
npx serve -s build -l 80
```

Open browser at:
```
http://localhost
```

📸 **Screenshot — React app running locally on port 80:**

![App Local](screenshots/01-app-local.png)

📸 **Screenshot — Terminal showing serve running on port 80:**

![App Local Terminal](screenshots/01-app-local-terminal.png)

---

## 🐳 Phase 2 - Docker

### Dockerfile

Since the repo provides a pre-built React app, Nginx directly serves the `build/` folder on **port 80**.

```dockerfile
# Serve the pre-built React app with Nginx on port 80
FROM nginx:alpine
COPY build/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### docker-compose.yml

```yaml
version: '3.8'
services:
  app:
    image: subashree06/dev:latest
    ports:
      - "80:80"
    restart: always
```

### Build Docker Image
```powershell
docker build -t subashree06/dev:latest .
```

📸 **Screenshot — Docker image build output:**

![Docker Build](screenshots/03-docker-build.png)

### Run Docker Container
```powershell
docker run -d -p 80:80 --name devops-app subashree06/dev:latest
docker ps
```

📸 **Screenshot — Docker container running:**

![Docker Running](screenshots/04-docker-running.png)

📸 **Screenshot — App running on browser via Docker (port 80):**

![App on Browser](screenshots/05-app-on-browser.png)

---

## 📜 Phase 3 - Bash Scripts

Two scripts automate the build and deployment process.

### build.sh — Builds and pushes Docker image to Docker Hub

```bash
#!/bin/bash
set -e

DOCKERHUB_USERNAME="subashree06"
BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$BRANCH" = "master" ]; then
  REPO="prod"
else
  REPO="dev"
fi

IMAGE="$DOCKERHUB_USERNAME/$REPO:latest"
docker build -t $IMAGE .
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
docker push $IMAGE
echo "Build complete!"
```

📸 **Screenshot — build.sh script in VS Code:**

![build.sh](screenshots/06-build-sh.png)

### deploy.sh — Pulls image and deploys on server

```bash
#!/bin/bash
set -e

DOCKERHUB_USERNAME="subashree06"
BRANCH=${1:-dev}

if [ "$BRANCH" = "master" ]; then
  REPO="prod"
else
  REPO="dev"
fi

IMAGE="$DOCKERHUB_USERNAME/$REPO:latest"
docker pull $IMAGE
docker-compose down || true
docker-compose up -d
echo "Deployment complete!"
```

📸 **Screenshot — deploy.sh script in VS Code:**

![deploy.sh](screenshots/07-deploy-sh.png)

---

## 🔀 Phase 4 - Version Control

All git operations performed via **CLI only**.

```powershell
# Initialize and setup
git init
git checkout -b dev
git remote add origin https://github.com/subashree06/devops-capstone.git

# Add and push
git add .
git commit -m "initial commit: add Dockerfile, scripts, and CI/CD config"
git push -u origin dev
```

- `.gitignore` — excludes `node_modules/`, `.env`
- `.dockerignore` — excludes `node_modules`, `.git`

📸 **Screenshot — Terminal showing git commands:**

![Git Terminal](screenshots/08-git-terminal.png)

📸 **Screenshot — GitHub dev branch with all files:**

![GitHub Dev Branch](screenshots/09-github-dev-branch.png)

📸 **Screenshot — .gitignore file content:**

![gitignore](screenshots/10-gitignore.png)

📸 **Screenshot — .dockerignore file content:**

![dockerignore](screenshots/11-dockerignore.png)

---

## 🐋 Phase 5 - Docker Hub

Two repositories created on Docker Hub:

| Repo | Visibility | Triggered By |
|------|-----------|-------------|
| `subashree06/dev` | Public | Push to `dev` branch |
| `subashree06/prod` | 🔒 Private | Merge to `master` branch |

### Push image to Docker Hub
```powershell
docker login
docker push subashree06/dev:latest
```

📸 **Screenshot — Terminal showing image push output:**

![DockerHub Terminal](screenshots/12-dockerhub-terminal.png)

📸 **Screenshot — Docker Hub repositories page:**

![DockerHub Repos](screenshots/13-dockerhub-repos.png)

📸 **Screenshot — Dev repo (Public):**

![DockerHub Dev](screenshots/14-dockerhub-dev.png)

📸 **Screenshot — Prod repo (Private 🔒):**

![DockerHub Prod](screenshots/15-dockerhub-prod.png)

📸 **Screenshot — Dev repo image tags:**

![DockerHub Dev Image](screenshots/16-dockerhub-dev-image.png)

📸 **Screenshot — Prod repo image tags:**

![DockerHub Prod Image](screenshots/17-dockerhub-prod-image.png)

📸 **Screenshot — Repo overview page:**

![DockerHub Repo Page](screenshots/18-dockerhub-repo-page.png)

---

## ⚙️ Phase 6 - Jenkins CI/CD

### Pipeline Flow

```
GitHub Push
    │
    ├── dev branch   ──► Build Image ──► Push to subashree06/dev
    │
    └── master branch ─► Build Image ──► Push to subashree06/prod
```

### Jenkinsfile

```groovy
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
                    docker stop dev-app || true
                    docker rm dev-app || true
                    docker run -d --name dev-app -p 80:80 subashree06/dev:latest
                '''
            }
        }
    }
    post {
        success { echo 'Pipeline SUCCESS ✅' }
        failure { echo 'Pipeline FAILED ❌ check logs' }
    }
}
```

### Jenkins Setup
- Jenkins installed on EC2 at port `8080`
- GitHub repo connected via webhook
- DockerHub credentials added (ID: `dockerhub-creds`)
- Multibranch pipeline job created
- Auto-triggers on push to `dev` and `master`

📸 **Screenshot — EC2 instance running:**

![EC2 Instance](screenshots/19-ec2-instance.png)

📸 **Screenshot — EC2 instance details:**

![EC2 Instance2](screenshots/20-ec2-instance2.png)

📸 **Screenshot — EC2 status checks:**

![EC2 Instance3](screenshots/21-ec2-instance3.png)

📸 **Screenshot — EC2 security group:**

![EC2 Security](screenshots/22-ec2-instance4.png)

📸 **Screenshot — EC2 connect page:**

![EC2 Connect](screenshots/23-ec2-instance5.png)

📸 **Screenshot — EC2 instance (AWS phase):**

![EC2 Instance AWS](screenshots/37-ec2-instance.png)

📸 **Screenshot — EC2 terminal output:**

![EC2 Terminal](screenshots/38-ec2-terminal.png)

📸 **Screenshot — Security group inbound rules:**

![Security Group](screenshots/39-security-group.png)

📸 **Screenshot — OnlineShop app live on EC2:**

![App on EC2](screenshots/40-app-on-ec2.png)

📸 **Screenshot — Jenkins login page:**

![Jenkins Login](screenshots/24-jenkins-login.png)

📸 **Screenshot — Jenkins dashboard:**

![Jenkins Dashboard](screenshots/25-jenkins-dashboard.png)

📸 **Screenshot — Jenkins pipeline configured:**

![Jenkins Pipeline](screenshots/26-jenkins-pipeline.png)

📸 **Screenshot — Jenkins GitHub credentials:**

![Jenkins Credentials](screenshots/27-jenkins-credentials.png)

📸 **Screenshot — Jenkins Docker Hub credentials:**

![Jenkins Docker Creds](screenshots/28-jenkins-docker-creds.png)

📸 **Screenshot — Jenkins build running:**

![Jenkins Build](screenshots/29-jenkins-build.png)

📸 **Screenshot — Jenkins pipeline stages:**

![Jenkins Stages](screenshots/30-jenkins-stages.png)

📸 **Screenshot — Jenkins build success ✅:**

![Jenkins Success](screenshots/31-jenkins-success.png)

📸 **Screenshot — Jenkins console output:**

![Jenkins Console](screenshots/32-jenkins-console.png)

📸 **Screenshot — GitHub webhook configured:**

![GitHub Webhook](screenshots/33-github-webhook.png)

📸 **Screenshot — Jenkins build output 1:**

![Jenkins Build Output](screenshots/34-jenkins-build-output.png)

📸 **Screenshot — Jenkins build output 2:**

![Jenkins Build Output2](screenshots/35-jenkins-build-output2.png)

📸 **Screenshot — Jenkins build output 3:**

![Jenkins Build Output3](screenshots/36-jenkins-build-output3.png)

---

## ☁️ Phase 7 - AWS Deployment

### EC2 Instance Details
- **Type:** t2.micro (Free Tier)
- **OS:** Ubuntu 22.04 LTS
- **Port:** 80 (HTTP)

### Security Group Rules

| Port | Source | Purpose |
|------|--------|---------|
| 80 | 0.0.0.0/0 | App — anyone can access |
| 8080 | 0.0.0.0/0 | Jenkins UI |
| 22 | My IP only | Secure SSH login |

### Connect & Deploy on EC2
```bash
# Connect
ssh -i devops-key.pem ubuntu@3.108.184.161

# Install Docker
sudo apt update
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker ubuntu

# Deploy
docker run -d --name dev-app -p 80:80 subashree06/dev:latest
```

### Application URL
```
http://3.108.184.161
```

---

## 📊 Phase 8 - Monitoring

Using **Uptime Kuma** (open-source) to monitor application health with downtime alerts.

```bash
docker run -d \
  --restart=always \
  -p 3001:3001 \
  -v uptime-kuma:/app/data \
  --name uptime-kuma \
  louislam/uptime-kuma:1
```

- Monitor: `http://3.108.184.161`
- Dashboard: `http://3.108.184.161:3001`
- Notification alert when app goes **down** 🔴

📸 **Screenshot — Uptime Kuma monitoring dashboard:**

![Monitoring](screenshots/41-monitoring-dashboard.png)

---

## 📤 Submission

| Item | Link |
|------|------|
| 🐙 GitHub Repo | https://github.com/subashree06/devops-capstone |
| 🌐 Deployed App | http://3.108.184.161 |
| 🐳 Docker Hub Dev | https://hub.docker.com/r/subashree06/dev |
| 🔒 Docker Hub Prod | https://hub.docker.com/r/subashree06/prod |

---

*Capstone Project — DevOps Application Deployment | GUVI × HCL*
