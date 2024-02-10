#!/bin/sh
set -ex

CONTAINER_NAME=$(docker ps -aqf "name=wordpress")
DATE=$(date +'%y.%m.%d-%H:%M:%S'.sql)

docker cp srcs/requirements/wordpress/sql/$1 $CONTAINER_NAME:/var/www/wordpress/$1

docker exec $CONTAINER_NAME wp db import $1
