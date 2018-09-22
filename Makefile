
DOCKER_IMAGE_NAME = shomatan/laravel-php-fpm:7.2.10-alpine
DOCKER_CODE_PATH  = /var/www/html

#.PHONY: create-project
#create-project:
#	docker run --rm \
#		-v ${PWD}:$(DOCKER_CODE_PATH) \
#		$(DOCKER_IMAGE_NAME) \
#		sh -c ' \
#			composer create-project --prefer-dist "laravel/laravel" /work "5.5.*" && \
#			mv /work/* $(DOCKER_CODE_PATH) \
#		'
