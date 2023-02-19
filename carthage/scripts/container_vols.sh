#!/bin/bash
# Find volumes associated to containers

volumes=$(docker volume ls  --format '{{.Name}}')

for volume in $volumes
do
  echo -n volume=$volume '->'
  docker ps -a --filter volume="$volume"  --format '{{.Names}}' | sed 's/^/  /'
done