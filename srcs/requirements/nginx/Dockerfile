FROM alpine:latest as base

RUN apk update &&\
	apk upgrade &&\
	apk add --no-cache\
	nginx

RUN mkdir -p /run/nginx

COPY healthcheck.sh /tmp/healthcheck.sh

COPY conf/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]

FROM base as singe-site-dev

COPY prod.conf /etc/nginx/http.d/prod.conf

FROM base as multi-site-dev

#RUN mkdir -p /etc/nginx/global

COPY conf/wordpress-multi-site-dev.conf /etc/nginx/http.d/wordpress-multi-site-dev.conf
#COPY conf/restrictions.conf /etc/nginx/http.d/restrictions.conf

FROM base as singe-site-prod

COPY prod.conf /etc/nginx/http.d/prod.conf

FROM base as multi-site-prod

COPY prod.conf /etc/nginx/http.d/prod.conf
