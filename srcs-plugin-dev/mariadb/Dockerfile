FROM alpine:3.18 AS base

RUN apk update && apk upgrade && apk add --no-cache\
	mariadb
        
COPY install.sh /tmp/install.sh

ENTRYPOINT sh /tmp/install.sh

FROM base AS dev

RUN apk add --no-cache mariadb-client

FROM base AS prod

RUN apk add --no-cache mariadb-client
