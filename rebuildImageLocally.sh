#!/bin/bash

REPOSITORY=aandrienko/build-che

echo "********************* Clean up containers and images *****************************"
CONTAINER_IDS=$(docker ps -q --filter=ancestor=${REPOSITORY})
docker rm -f ${CONTAINER_IDS}

docker rmi -f $(docker images ${REPOSITORY} -q)

echo "********************* Build image *****************************"
docker build -t ${REPOSITORY} .
