dev:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh localhost
	docker compose -f srcs/docker-compose-dev.yaml --env-file srcs/.env-dev up --build

multi:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh bio113-dev.com
	docker compose -f srcs/docker-compose-multi-site-wordpress.yaml --env-file srcs/.env-dev up --build

prod:
	sudo bash ./srcs/requirements/certbot/init-letsencrypt.sh olgrounds.dev www.olgrounds.dev
	docker compose -f srcs/docker-compose-prod.yaml --env-file srcs/.env-prod up --build -d
	bash ./srcs/tools/wait.sh
	sudo bash ./srcs/requirements/certbot/post-letsencrypt.sh olgrounds.dev www.olgrounds.dev
	#bash ./srcs/cert/bottest_renew.sh TODO
	bash ./srcs/tools/reload_nginx.sh

down:
	docker compose -f srcs/docker-compose-dev.yaml --env-file srcs/.env-dev -v down
	docker volume rm srcs_vol_mariadb srcs_vol_wordpress

copy:
	#TODO make a copy of the databse
	#I would say keep up to 3 of them localy
	#encrypt them
	#delete the oldes one if there are more than 3 copies

fclean:
	rm -rf ./srcs/requirements/certbot/conf/live
	rm -rf ./srcs/requirements/certbot/conf/options-ssl-nginx.conf
	rm -rf ./srcs/requirements/certbot/conf/ssl-dhparams.pem

