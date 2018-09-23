
DOCKER_IMAGE_NAME   = shomatan/laravel-php-fpm:7.2.10-alpine
DOCKER_CODE_PATH    = /var/www/html
DOCKER_NETWORK_NAME = laravel_network
DB_CONTAINER_NAME   = laravel-db
DB_IMAGE_NAME       = mysql:8.0.12

#.PHONY: create-project
#create-project:
#	docker run --rm \
#		-v ${PWD}:$(DOCKER_CODE_PATH) \
#		$(DOCKER_IMAGE_NAME) \
#		sh -c ' \
#			composer create-project --prefer-dist "laravel/laravel" /work "5.5.*" && \
#			mv /work/* $(DOCKER_CODE_PATH) \
#		'

.PHONY: init
init:
	@if ! `docker network ls | grep -q $(DOCKER_NETWORK_NAME)`; then\
		echo 'Created docker network: $(DOCKER_NETWORK_NAME)' && \
		docker network create $(DOCKER_NETWORK_NAME); \
	fi

.PHONY: composer
composer:
	docker run --rm \
		-v ${PWD}:$(DOCKER_CODE_PATH) \
		$(DOCKER_IMAGE_NAME) \
		sh -c 'composer ${ARG}'

.PHONY: artisan
artisan:
	make db-up && \
	docker exec $(DB_CONTAINER_NAME) \
	bash -c ' \
		until echo \\'\q\\' | mysql -u"root" -p"rootpassword" "homestead" ; do \
			>&2 echo "**** MySQL is unavailable - sleeping" && \
			sleep 1; \
		done \
	' && \
	docker run --rm \
		--net $(DOCKER_NETWORK_NAME) \
		-v ${PWD}:$(DOCKER_CODE_PATH) \
		$(DOCKER_IMAGE_NAME) \
		sh -c 'php artisan ${ARG}'

.PHONY: db-up
db-up:
	make init
	@if ! `docker ps | grep -q $(DB_CONTAINER_NAME)`; then\
		docker run -itd --name $(DB_CONTAINER_NAME) \
			--net $(DOCKER_NETWORK_NAME) \
			-e MYSQL_ROOT_PASSWORD=rootpassword \
			-e MYSQL_DATABASE=homestead \
			-v ${PWD}/docker/volumes/mysql:/var/lib/mysql \
			-p 33062:3306 \
			$(DB_IMAGE_NAME); \
	fi

.PHONY: destory
destory:
	@if `docker ps | grep -q $(DB_CONTAINER_NAME)`; then\
		docker rm -f $(DB_CONTAINER_NAME); \
	fi
	@if `docker network ls | grep -q $(DOCKER_NETWORK_NAME)`; then\
		docker network rm $(DOCKER_NETWORK_NAME); \
	fi
	rm -rf docker/volumes/mysql