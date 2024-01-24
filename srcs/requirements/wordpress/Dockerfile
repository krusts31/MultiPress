FROM alpine:edge as base

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories &&\
	apk update && apk upgrade && apk add --no-cache\
	php82\
	php82-tokenizer\
	php82-xmlwriter\
	php82-ctype\
	php82-phar\
	php82-openssl\
	php82-curl\
	php82-dom\
	php82-exif\
	php82-fileinfo\
	php82-sodium\
	php82-mbstring\
	php82-mysqli\
	php82-xml\
	php82-zip\
	php82-cgi\
	php82-pecl-imagick\
	php82-fpm\
	php82-session\
	php82-gd\
	php82-iconv\
	php82-intl\
	mariadb-client\
	tini
	
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN adduser -S nginx &&\
	addgroup -S nginx

RUN chmod +x wp-cli.phar &&\
	mv wp-cli.phar /usr/bin/wp

WORKDIR /var/www/html

COPY ./php82-conf/www.conf /etc/php82/php-fpm.d/www.conf
COPY ./php82-conf/php.ini /etc/php82/php.ini

#COPY ./lang/woocommerce-de_DE.po /var/www/html/wp-content/languages/loco/plugins/woocommerce-de_DE.po
COPY ./lang/woocommerce-et.po /var/www/html/wp-content/languages/loco/plugins/woocommerce-et.po
COPY ./lang/woocommerce-lt_LT.po /var/www/html/wp-content/languages/loco/plugins/woocommerce-lt_LT.po
COPY ./lang/woocommerce-lv.po /var/www/html/wp-content/languages/loco/plugins/woocommerce-lv.po

COPY health-checks/healthcheck.sh /tmp/healthcheck.sh

ENTRYPOINT ["tini", "--"]

FROM base as plugin-dev

RUN apk add --no-cahce php82-ctype\
	php82-tokenizer\
	php82-xmlwriter\
	subversion\
	composer\
	git\
	bash\
	phpunit\
	openssh-client

COPY plugin-dev-install.sh /tmp/plugin-dev-install.sh

CMD sh /tmp/plugin-dev-install.sh

FROM base as wordpress-core

COPY core-wordpress-install.sh /tmp/core-wordpress-install.sh

CMD sh /tmp/core-wordpress-install.sh

FROM base as multi-site-dev

COPY init-scripts/multi-site-wordpress-install.sh /tmp/multi-site-wordpress-install.sh

CMD sh /tmp/multi-site-wordpress-install.sh
