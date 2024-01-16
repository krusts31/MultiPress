#!/bin/sh

# Check for required environment variables
for var in WORDPRESS_DATABASE_NAME MARIADB_USER MARIADB_USER_PASSWORD MARIADB_HOST_NAME WORDPRESS_TITLE WORDPRESS_ADMIN WORDPRESS_ADMIN_PASSWORD WORDPRESS_ADMIN_EMAIL WORDPRESS_USER WORDPRESS_USER_EMAIL WORDPRESS_USER_ROLE WORDPRESS_USER_PASSWORD WORDPRESS_URL; do
	eval "value=\$$var"
	if [ -z "$value" ]; then
		echo "Error: $var environment variable not set."
		exit 1
	fi
done

if [ ! -f "/var/www/html/wp-config.php" ]; then
	wp core download --allow-root

	wp config create --dbname=$WORDPRESS_DATABASE_NAME --dbuser=$MARIADB_USER --dbpass=$MARIADB_USER_PASSWORD --dbhost=$MARIADB_HOST_NAME --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	wp core install --allow-root --url=$WORDPRESS_URL  --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL
	wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=$WORDPRESS_USER_ROLE --user_pass=$WORDPRESS_USER_PASSWORD --allow-root 
	wp plugin delete akismet --allow-root 
	wp plugin delete hello --allow-root 
	wp theme delete $(wp theme list --status=inactive --field=name --allow-root) --allow-root  
	wp plugin update --all --allow-root
	wp plugin install woocommerce --activate --allow-root
	wp config set WP_SITEWORDPRESS_URL "https://$WORDPRESS_URL/" --type=constant
	wp config set WP_HOME "https://$WORDPRESS_URL/" --type=constant

	#this is for the dev not sure if I need this on the prodoction version
	wp package install wp-cli/doctor-command:@stable

	wp option update permalink_structure '/%postname%/' --allow-root

	mkdir -p wp-content/upgrade
	chown -R nginx:nginx /var/www/html/

	find /var/www/html/ -type d -exec chmod 755 {} \;
	find /var/www/html/ -type f -exec chmod 644 {} \;

	#this is for the dev
	cd ./wp-content/plugins/multipress
	bash bin/install-wp-tests.sh wordpress_test root $MARIADB_ROOT_PASSWORD $MARIADB_HOST_NAME 6.4.2
	composer install
	cd -
	echo "WP installation done"
fi

exec /usr/sbin/php-fpm82 -F -R