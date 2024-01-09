ARG NODE_VERSION=16.20.0

FROM node:${NODE_VERSION}-alpine AS node

FROM alpine:edge as base

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk update && apk upgrade && apk add --no-cache \
	php82 \
	php82-phar \
	php82-openssl \
	php82-curl \
	php82-dom \
	php82-exif \
	php82-fileinfo \
	php82-sodium \
	php82-mbstring \
	php82-mysqli \
	php82-xml \
	php82-zip \
	php82-cgi \
	php82-pecl-imagick \
	php82-fpm \
	php82-session \
	php82-gd \
	php82-iconv \
	php82-intl \
	mariadb-client \
	tini
	
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN adduser -S nginx &&	addgroup -S nginx

RUN chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/bin/wp

WORKDIR /var/www/html

COPY www.conf /etc/php82/php-fpm.d/www.conf
#todo editd file upload size
COPY install.sh /tmp/install.sh
COPY healthcheck.sh /tmp/healthcheck.sh

ENTRYPOINT ["tini", "--"]

CMD sh /tmp/install.sh

FROM base as dev

RUN apk add --no-cache php82-simplexml\
	bash\
	php82-xmlwriter\
	php82-tokenizer\
	php82-ctype

COPY woocommerce-gutenberg-products-block/  /tmp/woocommerce-gutenberg-products-block/
COPY woocommerce/  /tmp/woocommerce/

COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

RUN npm install -g pnpm

COPY install-dev.sh /tmp/install-dev.sh

CMD sh /tmp/install-dev.sh
