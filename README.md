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
│   ├── 01-app-local.png
│   ├── 02-dockerfile.png
│   ├── 03-docker-build.png
│   ├── 04-docker-running.png
│   ├── 05-app-on-browser.png
│   ├── 06-build-sh.png
│   ├── 07-deploy-sh.png
│   ├── 08-github-dev-branch.png
│   ├── 09-gitignore-dockerignore.png
│   ├── 10-dockerhub-dev-repo.png
│   ├── 11-dockerhub-prod-repo.png
│   ├── 12-jenkins-installed.png
│   ├── 13-jenkins-pipeline.png
│   ├── 14-jenkins-build-success.png
│   ├── 15-ec2-instance.png
│   ├── 16-security-group.png
│   ├── 17-app-live-ec2.png
│   └── 18-monitoring-dashboard.png
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

📸 **Screenshot — Dockerfile in VS Code:**

![Dockerfile](screenshots/02-dockerfile.png)

---

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

📸 **Screenshot — Docker image build output (679):**

![Docker Build](screenshots/03-docker-build.png)

---

### Run Docker Container
```powershell
docker run -d -p 80:80 --name devops-app subashree06/dev:latest
```

### Verify container is running
```powershell
docker ps
```

📸 **Screenshot — App running on browser via Docker port 80 (681):**

![App on Browser](screenshots/04-docker-running.png)

📸 **Screenshot — Docker container running `docker ps` (680):**

![Docker Running](screenshots/05-app-on-browser.png)

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

---

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

- `.gitignore` — excludes `node_modules/`, `build/`, `.env`
- `.dockerignore` — excludes `node_modules`, `.git`, `build`

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
```bash
docker login
docker push subashree06/dev:latest
```

📸 **Screenshot — Docker Hub dev repo (public):**

![DockerHub Dev](screenshots/10-dockerhub-dev-repo.png)

📸 **Screenshot — Docker Hub prod repo (private):**

![DockerHub Prod](screenshots/11-dockerhub-prod-repo.png)

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
        DOCKERHUB_PASSWORD = credentials('dockerhub-creds')
    }
    stages {
        stage('Clone')        { steps { checkout scm } }
        stage('Build & Push') { steps { sh './build.sh' } }
        stage('Deploy')       { steps { sh "./deploy.sh ${env.BRANCH_NAME}" } }
    }
}
```

### Jenkins Install on EC2
```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update && sudo apt install -y jenkins
sudo systemctl start jenkins
```

📸 **Screenshot — Jenkins dashboard accessible at port 8080:**

![Jenkins Installed](screenshots/12-jenkins-installed.png)

📸 **Screenshot — Jenkins pipeline configured:**

![Jenkins Pipeline](screenshots/13-jenkins-pipeline.png)

📸 **Screenshot — Jenkins build success ✅:**

![Jenkins Build Success](screenshots/14-jenkins-build-success.png)

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
ssh -i your-key.pem ubuntu@YOUR-EC2-IP

# Install Docker
sudo apt update
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker ubuntu

# Deploy
./deploy.sh
```

📸 **Screenshot — EC2 instance running in AWS console:**

![EC2 Instance](screenshots/15-ec2-instance.png)

📸 **Screenshot — Security Group inbound rules:**

![Security Group](screenshots/16-security-group.png)

📸 **Screenshot — App live on EC2 public IP:**

![App Live](screenshots/17-app-live-ec2.png)

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

- Monitor: `http://YOUR-EC2-IP`
- Dashboard: `http://YOUR-EC2-IP:3001`
- Notification alert when app goes **down** 🔴

📸 **Screenshot — Uptime Kuma showing app UP 🟢:**

![Monitoring](screenshots/18-monitoring-dashboard.png)

---

## 📤 Submission

| Item | Link |
|------|------|
| 🐙 GitHub Repo | https://github.com/subashree06/devops-capstone |
| 🌐 Deployed App | http://YOUR-EC2-PUBLIC-IP |
| 🐳 Docker Hub Dev | https://hub.docker.com/r/subashree06/dev |
| 🔒 Docker Hub Prod | https://hub.docker.com/r/subashree06/prod |

---

*Capstone Project — DevOps Application Deployment | GUVI × HCL*
