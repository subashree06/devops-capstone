#!/bin/bash

set -e

echo "Installing dependencies..."
npm install

echo "Building React app..."
npm run build

echo "Building Docker image..."
docker build -t subashree06/dev:latest .

echo "Logging into DockerHub..."
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

echo "Pushing image..."
docker push subashree06/dev:latest