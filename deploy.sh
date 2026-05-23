#!/bin/bash
set -e

DOCKERHUB_USERNAME=subashree06
BRANCH=${1:-dev}

if [ "$BRANCH" = "master" ]; then
  REPO="prod"
else
  REPO="dev"
fi

IMAGE="$DOCKERHUB_USERNAME/$REPO:latest"

echo "Pulling image: $IMAGE"
docker pull $IMAGE

echo "Stopping old container..."
docker-compose down || true

echo "Starting new container..."
docker-compose up -d

echo "Deployment complete! App running on port 80."