#!/bin/bash
#Exit immediately on error
set -e

# Set script vars
DOCKER_TAG="kibana"
HOST=$DB_IP

ssh "$PI_USER@$HOST" "sudo mkdir -p /var/kibana/data" || true
ssh "$PI_USER@$HOST" "sudo chmod -R 777 /var/kibana/data" || true
ssh "$PI_USER@$HOST" "sudo mkdir -p /var/kibana/config" || true
ssh "$PI_USER@$HOST" "sudo chmod -R 777 /var/kibana/config" || true

echo "Setting builder to default"
docker buildx use default

echo "Building target for arm64"
docker buildx build --platform linux/arm64 -t $DOCKER_TAG .

echo "Stopping old container"
ssh "$PI_USER@$HOST" "docker stop $DOCKER_TAG " || true

echo "Removing old container"
ssh "$PI_USER@$HOST" "docker container rm $DOCKER_TAG " || true

echo "Pushing new image"
docker save $DOCKER_TAG | bzip2 | ssh -l $PI_USER $HOST docker load

echo "Starting Container"
ssh "$PI_USER@$HOST" "docker run -d --network host -v /var/kibana/data:/usr/share/kibana/data -v /var/kibana/config:/usr/share/kibana/config --restart unless-stopped --name $DOCKER_TAG \"$DOCKER_TAG\""

echo "Removing dangling images"
ssh "$PI_USER@$HOST" 'docker image rm $(docker images -f "dangling=true" -q)'
