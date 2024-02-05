dev:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh bio113-dev.com
	docker compose -f srcs/docker-compose-dev.yaml --env-file srcs/.env-dev up --build

prod:
	sudo bash ./srcs/requirements/certbot/init-letsencrypt.sh olgrounds.dev www.olgrounds.dev
	docker compose -f srcs/docker-compose-prod.yaml --env-file srcs/.env-prod up --build -d
	bash ./srcs/tools/wait.sh
	sudo bash ./srcs/requirements/certbot/post-letsencrypt.sh olgrounds.dev www.olgrounds.dev
	#bash ./srcs/cert/bottest_renew.sh TODO
	bash ./srcs/tools/reload_nginx.sh

multi-dev:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh bio113-dev.com
	docker compose -f srcs/docker-compose-multi-site-wordpress.yaml --env-file srcs/.env-dev up --build

multi-prod:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh olgrounds.dev lt.olgrounds.dev et.olgrounds.dev lv.olgrounds.dev de.olgrounds.dev files.olgrounds.dev
	docker compose -f srcs/docker-compose-multi-site-wordpress.yaml --env-file srcs/.env-prod up --build -d
	bash ./srcs/tools/wait.sh
	bash ./srcs/requirements/certbot/post-letsencrypt.sh olgrounds.dev lt.olgrounds.dev et.olgrounds.dev lv.olgrounds.dev de.olgrounds.dev files.olgrounds.dev
	#bash ./srcs/cert/bottest_renew.sh TODO
	bash ./srcs/tools/reload_nginx.sh


down:
	docker compose -f srcs/docker-compose-dev.yaml --env-file srcs/.env-dev -v down
	docker volume rm srcs_vol_mariadb srcs_vol_wordpress

down-multi:
	docker compose -f srcs/docker-compose-multi-site-wordpress.yaml --env-file srcs/.env-dev -v down
	docker volume rm srcs_vol_mariadb srcs_vol_wordpress

fclean:
	rm -rf ./srcs/requirements/certbot/conf/live
	rm -rf ./srcs/requirements/certbot/conf/options-ssl-nginx.conf
	rm -rf ./srcs/requirements/certbot/conf/ssl-dhparams.pem
