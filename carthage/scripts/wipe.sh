#!/bin/bash

docker compose down
docker container rm $(docker ps -qa) > /dev/null 2>&1
docker volume rm $(docker volume ls -q) > /dev/null 2>&1
