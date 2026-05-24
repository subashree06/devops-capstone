#!set -e

echo "Installing dependencies..."
npm install

echo "Building React app..."
npm run build

echo "Building Docker image..."
docker build -t $DOCKER_USER/dev:latest .

echo "Logging into DockerHub..."
echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

echo "Pushing image..."
docker push $DOCKER_USER/dev:latest/bin/bash

