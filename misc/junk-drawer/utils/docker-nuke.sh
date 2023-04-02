#!/bin/bash

# nuke all containers, images, etc

docker stop $(docker ps -a -q) > /dev/null 2>&1
docker volume rm $(docker volume ls -q) > /dev/null 2>&1
docker container rm $(docker ps -qa) > /dev/null 2>&1
docker system prune --all --force > /dev/null 2>&1
