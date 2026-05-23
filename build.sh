#!/bin/bash
set -e

DOCKERHUB_USERNAME="subashree06"
BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Current branch: $BRANCH"

if [ "$BRANCH" = "master" ]; then
  REPO="prod"
else
  REPO="dev"
fi

IMAGE="$DOCKERHUB_USERNAME/$REPO:latest"

echo "Building image: $IMAGE"
docker build -t $IMAGE .

echo "Logging into Docker Hub..."
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

echo "Pushing image: $IMAGE"
docker push $IMAGE

echo "Build complete!"