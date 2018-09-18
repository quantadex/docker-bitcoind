#!/usr/bin/env bash

set -e

REPO="691216021071.dkr.ecr.us-east-1.amazonaws.com"
name="bitcoind"

$(aws ecr get-login --no-include-email --region us-east-1)  

VER=git-$(git rev-parse --short HEAD)
image="$REPO/$name:$VER"
dockerfile="Dockerfile"

echo "Build: $name"
if [[ $(aws ecr describe-repositories | grep $name | wc -l) = "0" ]]; then
   aws ecr create-repository --repository-name $name
fi

docker build -t $image -f $dockerfile .
docker tag $image $REPO/$name:latest
docker push $image
docker push $REPO/$name:latest

echo "... done: $image"
echo

