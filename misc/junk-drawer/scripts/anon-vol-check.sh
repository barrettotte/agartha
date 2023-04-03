#!/bin/bash

# Find containers associated with anonymous volumes

for v in $(docker volume ls --format "{{.Name}}")
do
  containers="$(docker ps -a --filter volume=$v --format '{{.Names}}' | tr '\n' ',')"
  echo "volume $v -> [$containers]"
done
