#!/bin/sh
set -ex
NODE_VERSION=16.20.0

#install composer
apt install curl php-cli php-mbstring git unzip -y

curl -sS https://getcomposer.org/installer -o composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`

php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#install node

apt install nodejs npm -y

#install nvm

nvm install $NODE_VERSION
nvm use $NODE_VERSION
nvm alias default $NODE_VERSION

#install pnmp
npm install -g pnpm

#install wp
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

/usr/sbin/adduser  --disabled-password --gecos "" nginx

chmod +x wp-cli.phar
mv wp-cli.phar /usr/bin/wp

mkdir -p /var/www/html

cd /var/www/html

mv /tmp/www.conf /etc/php82/php-fpm.d/www.conf

# Check for required environment variables
for var in WORDPRESS_DATABASE_NAME MARIADB_USER MARIADB_USER_PASSWORD MARIADB_HOST_NAME WORDPRESS_TITLE WORDPRESS_ADMIN WORDPRESS_ADMIN_PASSWORD WORDPRESS_ADMIN_EMAIL WORDPRESS_USER WORDPRESS_USER_EMAIL WORDPRESS_USER_ROLE WORDPRESS_USER_PASSWORD WORDPRESS_URL; do
	eval "value=\$$var"
	if [ -z "$value" ]; then
		echo "Error: $var environment variable not set."
		exit 1
	fi
done

#install wordpress
if [ ! -f "/var/www/html/wp-config.php" ]; then
	wp core download --allow-root
	wp config create --dbname=$WORDPRESS_DATABASE_NAME --dbuser=$MARIADB_USER --dbpass=$MARIADB_USER_PASSWORD --dbhost=$MARIADB_HOST_NAME --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	wp core install --allow-root --url=$WORDPRESS_URL  --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL
	wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=$WORDPRESS_USER_ROLE --user_pass=$WORDPRESS_USER_PASSWORD --allow-root 
	wp plugin delete $(wp plugin list --status=inactive --field=name --allow-root) --allow-root 
	wp theme delete $(wp theme list --status=inactive --field=name --allow-root) --allow-root  
	wp plugin update --all --allow-root
	sed -i "37s/.*/define( 'WP_SITEURL', 'https:\/\/$WORDPRESS_URL\/');/" ./wp-config.php
	sed -i "40s/.*/define( 'WP_HOME', 'https:\/\/$WORDPRESS_URL\/');/" ./wp-config.php
	wp package install git@github.com:wp-cli/doctor-command.git

	wp option update permalink_structure '/%postname%/'
	mkdir /var/www/html/ wp-content/upgrade
	chown -R nginx:nginx /var/www/html/
	find /var/www/html/ -type d -exec chmod 755 {} \;
	find /var/www/html/ -type f -exec chmod 644 {} \;
fi

git clone https://github.com/woocommerce/woocommerce.git wp-content/pluginst/woocommerce

cd wp-contect/plugins/woocommerce
pnpm install
pnpm build

exec /usr/sbin/php-fpm82 -F -R
