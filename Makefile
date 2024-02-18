single-dev:
	#create ssh script for local dev
	bash ./srcs/requirements/certbot/init-letsencrypt.sh bio113-dev.com
	docker compose -f srcs/docker-compose-dev.yaml --env-file srcs/.env-dev up --build

single-prod:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh olgrounds.dev
	docker compose -f srcs/docker-compose-prod.yaml --env-file srcs/.env-prod up --build -d
	bash ./srcs/tools/wait.sh
	bash ./srcs/requirements/certbot/post-letsencrypt.sh olgrounds.dev
	#bash ./srcs/cert/bottest_renew.sh TODO
	bash ./srcs/tools/reload_nginx.sh

multi-dev:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh bio113-dev.com lt.bio113-dev.com et.bio113-dev.com lv.bio113-dev.com de.bio113-dev.com files.bio113-dev.com
	docker compose -f srcs/docker-compose-multi-site-dev.yaml --env-file srcs/.env-dev up --build

multi-prod:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh olgrounds.dev lt.olgrounds.dev et.olgrounds.dev lv.olgrounds.dev de.olgrounds.dev files.olgrounds.dev
	docker compose -f srcs/docker-compose-multi-site-prod.yaml --env-file srcs/.env-prod up --build -d
	bash ./srcs/tools/wait.sh
	bash ./srcs/requirements/certbot/post-letsencrypt.sh olgrounds.dev lt.olgrounds.dev et.olgrounds.dev lv.olgrounds.dev de.olgrounds.dev files.olgrounds.dev
	#bash ./srcs/cert/bottest_renew.sh TODO
	bash ./srcs/tools/reload_nginx.sh


down:
	docker compose -f srcs/docker-compose-dev.yaml --env-file srcs/.env-dev -v down
	docker volume rm srcs_vol_mariadb srcs_vol_wordpress

down-multi:
	docker compose -f srcs/docker-compose-multi-site-dev.yaml --env-file srcs/.env-dev -v down
	docker volume rm srcs_vol_mariadb srcs_vol_wordpress

fclean:
	rm -rf ./srcs/requirements/certbot/conf/live
	rm -rf ./srcs/requirements/certbot/conf/options-ssl-nginx.conf
	rm -rf ./srcs/requirements/certbot/conf/ssl-dhparams.pem

save:
	bash ./srcs/tools/database_backup.sh

import:
	bash ./srcs/tools/import_database.sh 24.02.18-15.38.03.sql
