#!/bin/bash

# Your Docker container names
CONTAINERS=("srcs-nginx" "srcs-mariadb" "srcs-wordpress")  # Add your container names here

# Slack webhook URL
WEBHOOK_URL="https://discordapp.com/api/webhooks/1167852969522376804/1cfvD4hYRK2UNxAL9m7lKViaGGbKx6CVZes2EJEgjfCn6tUKZcNp_gl4abLkFNnX9qvt"

# Loop through each container to check its status
for CONTAINER in "${CONTAINERS[@]}"; do
    docker inspect  $CONTAINER

    sleep 4
   # if [ "$STATUS" != "running" ]; then
   #     curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"🚨 Container $CONTAINER has status: $STATUS 🚨\"}" $WEBHOOK_URL
   # elif [ -n "$HEALTH" ] && [ "$HEALTH" != "healthy" ]; then
   #     curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"🚨 Container $CONTAINER is not healthy: $HEALTH 🚨\"}" $WEBHOOK_URL
   # fi
done

