# 🚀 DevOps Application Deployment Capstone

> A production-ready deployment pipeline for a React application using Docker, Jenkins CI/CD, AWS EC2, and open-source monitoring.

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Setup & Installation](#-setup--installation)
- [Docker](#-docker)
- [Bash Scripts](#-bash-scripts)
- [Version Control](#-version-control)
- [Docker Hub](#-docker-hub)
- [Jenkins CI/CD Pipeline](#-jenkins-cicd-pipeline)
- [AWS Deployment](#-aws-deployment)
- [Monitoring](#-monitoring)
- [Output Screenshots](#-output-screenshots)
- [Submission](#-submission)

---

## 📌 Project Overview

This project demonstrates a complete DevOps workflow — from source code to a live, production-ready React application deployed on AWS EC2. The pipeline automates building, testing, and deploying Docker images using Jenkins, triggered by GitHub branch activity.

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
devops-build/
├── public/
├── src/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── .gitignore
├── Jenkinsfile
├── build.sh
├── deploy.sh
└── README.md
```

---

## ⚙️ Setup & Installation

### Prerequisites
- Docker & Docker Compose installed
- Git installed
- Node.js 18+ (for local development)

### Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git
cd devops-build
git checkout dev
```

### Run Locally

```bash
npm install
npm start
# App runs at http://localhost:3000
```

---

## 🐳 Docker

### Dockerfile

Multi-stage build — builds the React app and serves it via Nginx on **port 80**.

```dockerfile
# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### docker-compose.yml

```yaml
version: '3.8'
services:
  app:
    image: your-dockerhub-username/dev:latest
    ports:
      - "80:80"
    restart: always
```

### Build & Run Manually

```bash
docker build -t devops-app .
docker-compose up -d
# App available at http://localhost:80
```

---

## 📜 Bash Scripts

### build.sh — Builds and pushes Docker image

Detects current git branch and pushes to the correct Docker Hub repo (`dev` or `prod`).

```bash
chmod +x build.sh
./build.sh
```

### deploy.sh — Pulls image and deploys on server

```bash
chmod +x deploy.sh
./deploy.sh
```

---

## 🔀 Version Control

All git operations performed via **CLI only**.

```bash
# Create dev branch and push
git checkout -b dev
git add .
git commit -m "feat: add Dockerfile, compose, and CI/CD scripts"
git push -u origin dev

# Merge to master (triggers prod deployment)
git checkout master
git merge dev
git push origin master
```

**Files included:**
- `.gitignore` — excludes `node_modules/`, `build/`, `.env`
- `.dockerignore` — excludes `node_modules`, `.git`, `build`

---

## 🐋 Docker Hub

Two repositories created:

| Repo | Visibility | Used When |
|------|-----------|-----------|
| `your-username/dev` | Public | Push to `dev` branch |
| `your-username/prod` | **Private** | Merge to `master` branch |

Docker Hub Profile: `https://hub.docker.com/u/your-username`

---

## ⚙️ Jenkins CI/CD Pipeline

### Pipeline Flow

```
GitHub Push
    │
    ├── dev branch  ──► Build Image ──► Push to Docker Hub (dev repo)
    │
    └── master branch ─► Build Image ──► Push to Docker Hub (prod repo)
```

### Jenkinsfile

```groovy
pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = 'your-dockerhub-username'
        DOCKERHUB_PASSWORD = credentials('dockerhub-creds')
    }
    stages {
        stage('Clone') { steps { checkout scm } }
        stage('Build & Push') { steps { sh './build.sh' } }
        stage('Deploy') { steps { sh './deploy.sh' } }
    }
}
```

### Jenkins Setup
- Installed on EC2 at port `8080`
- Connected to GitHub repo via webhook
- Auto-triggers on push to `dev` and `master` branches

---

## ☁️ AWS Deployment

### EC2 Instance
- **Type:** t2.micro (Free Tier)
- **OS:** Ubuntu 22.04 LTS
- **Region:** ap-south-1 (or your region)

### Security Group Rules

| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 80 | HTTP | 0.0.0.0/0 | App access (public) |
| 8080 | TCP | 0.0.0.0/0 | Jenkins UI |
| 22 | SSH | My IP only | Secure server login |

### Connect to EC2

```bash
ssh -i your-key.pem ubuntu@YOUR-EC2-PUBLIC-IP
```

### Application URL
```
http://YOUR-EC2-PUBLIC-IP
```

---

## 📊 Monitoring

Using **Uptime Kuma** (open-source, self-hosted) to monitor application health.

```bash
docker run -d \
  --restart=always \
  -p 3001:3001 \
  -v uptime-kuma:/app/data \
  --name uptime-kuma \
  louislam/uptime-kuma:1
```

- Monitor URL: `http://YOUR-EC2-IP:3001`
- Monitors: `http://YOUR-EC2-IP` (React app)
- **Notifications:** Configured to alert when the app goes down (Email/Telegram)

---

## 📸 Output Screenshots

> Screenshots are placed in the `/screenshots` folder.

| # | Screenshot | Description |
|---|-----------|-------------|
| 1 | `screenshots/01-app-running.png` | React app live on port 80 |
| 2 | `screenshots/02-dockerfile.png` | Dockerfile content |
| 3 | `screenshots/03-docker-compose.png` | docker-compose.yml |
| 4 | `screenshots/04-docker-build.png` | Docker image build output |
| 5 | `screenshots/05-dockerhub-dev.png` | Docker Hub dev repo (public) |
| 6 | `screenshots/06-dockerhub-prod.png` | Docker Hub prod repo (private) |
| 7 | `screenshots/07-github-dev-branch.png` | GitHub dev branch commits |
| 8 | `screenshots/08-jenkins-pipeline.png` | Jenkins pipeline success |
| 9 | `screenshots/09-jenkins-webhook.png` | GitHub webhook config |
| 10 | `screenshots/10-ec2-instance.png` | EC2 instance running |
| 11 | `screenshots/11-security-group.png` | AWS Security Group rules |
| 12 | `screenshots/12-monitoring.png` | Uptime Kuma dashboard |

---

## 📤 Submission

- **GitHub Repo URL:** `https://github.com/YOUR-USERNAME/YOUR-REPO`
- **Deployed App URL:** `http://YOUR-EC2-PUBLIC-IP`
- **Docker Hub (dev):** `https://hub.docker.com/r/YOUR-USERNAME/dev`
- **Docker Hub (prod):** `https://hub.docker.com/r/YOUR-USERNAME/prod`

---

## 👤 Author

**Your Name**  
[GitHub](https://github.com/your-username) | [LinkedIn](https://linkedin.com/in/your-profile)

---

*Capstone Project — DevOps Application Deployment | GUVI × HCL*
