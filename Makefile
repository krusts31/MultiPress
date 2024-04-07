up-blog-dev:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh blog-dev.com
	docker compose -f srcs/docker-compose-blog-dev.yaml --env-file srcs/.env-blog-dev up --build

down-blog-dev:
	docker compose -f srcs/docker-compose-blog-dev.yaml --env-file srcs/.env-blog-dev -v down 
	docker volume rm srcs_vol_mariadb srcs_vol_wordpress

up-store-dev:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh store-dev.com
	docker compose -f srcs/docker-compose-store-dev.yaml --env-file srcs/.env-store-dev up --build

down-store-dev:
	docker compose -f srcs/docker-compose-store-dev.yaml --env-file srcs/.env-store-dev -v down
	docker volume rm srcs_vol_mariadb srcs_vol_wordpress

up-multi-dev:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh bio113-dev.com lt.bio113-dev.com et.bio113-dev.com lv.bio113-dev.com de.bio113-dev.com files.bio113-dev.com
	docker compose -f srcs/docker-compose-multi-site-dev.yaml --env-file srcs/.env-dev up --build

down-multi-dev:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh bio113-dev.com lt.bio113-dev.com et.bio113-dev.com lv.bio113-dev.com de.bio113-dev.com files.bio113-dev.com
	docker compose -f srcs/docker-compose-multi-site-dev.yaml --env-file srcs/.env-dev up --build

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

multi-staging:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh olgrounds.dev lt.olgrounds.dev et.olgrounds.dev lv.olgrounds.dev de.olgrounds.dev files.olgrounds.dev
	docker compose -f srcs/docker-compose-multi-site-stage.yaml --env-file srcs/.env-dev up --build

multi-prod:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh olgrounds.dev lt.olgrounds.dev et.olgrounds.dev lv.olgrounds.dev de.olgrounds.dev files.olgrounds.dev
	docker compose -f srcs/docker-compose-multi-site-prod.yaml --env-file srcs/.env-prod up --build -d
	bash ./srcs/tools/wait.sh
	bash ./srcs/requirements/certbot/post-letsencrypt.sh olgrounds.dev lt.olgrounds.dev et.olgrounds.dev lv.olgrounds.dev de.olgrounds.dev files.olgrounds.dev
	#bash ./srcs/cert/bottest_renew.sh TODO
	bash ./srcs/tools/reload_nginx.sh

fclean:
	rm -rf ./srcs/requirements/certbot/conf/live
	rm -rf ./srcs/requirements/certbot/conf/options-ssl-nginx.conf
	rm -rf ./srcs/requirements/certbot/conf/ssl-dhparams.pem

save:
	bash ./srcs/tools/database_backup.sh

import:
	bash ./srcs/tools/import_database.sh 24.02.18-16.21.42.sql

stop:
	docker stop -t 0 $(shell docker ps -q)
