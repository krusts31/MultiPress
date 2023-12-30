FROM alpine:3.18 as base

RUN apk update &&\
	apk upgrade &&\
	apk add --no-cache\
	nginx

RUN mkdir -p /run/nginx

COPY healthcheck.sh /tmp/healthcheck.sh

COPY nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]

FROM base as dev

COPY dev.conf /etc/nginx/http.d/dev.conf

FROM base as prod

COPY prod.conf /etc/nginx/http.d/prod.conf
