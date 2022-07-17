define create_db
	@mysql --execute="CREATE USER IF NOT EXISTS 'forge'@'localhost';"
	@mysql --execute="CREATE DATABASE IF NOT EXISTS $1;"
	@mysql --execute="GRANT ALL PRIVILEGES ON *.* TO 'forge'@'localhost';"
endef

define drop_db
	@mysql --execute="DROP DATABASE IF EXISTS $1;"
	@mysql --execute="DROP USER IF EXISTS 'forge'@'localhost';"
	@mysql --execute="CREATE USER 'forge'@'localhost';"
	@mysql --execute="CREATE DATABASE $1;"
	@mysql --execute="GRANT ALL PRIVILEGES ON *.* TO 'forge'@'localhost';"
endef

create_db_testing:
	$(call create_db,key_value_store_testing)

drop_db_testing:
	$(call drop_db,key_value_store_testing)

setup_db_testing:
	make create_db_testing
	php artisan migrate --env=testing

test:
	make setup_db_testing
	vendor/bin/phpunit


####################
# usage
 #   > make build env=local proxy_open_port=80
 # 2.make build example(PROXY don't need use.)
 #   > make build env=local
 #
 # * ssh private key path *
 # please read README
 #

# get argument(proxy open port)
PROXY_PORT=80
ifdef proxy_open_port
	PROXY_PORT=-p $(proxy_open_port):$(PROXY_PORT)
else
	PROXY_PORT_OPTION=
endif

# get argument(database open port)
DB_PORT=3306
ifdef database_open_port
	DB_PORT_OPTION=-p $(database_open_port):$(DB_PORT)
else
	DB_PORT_OPTION=
endif

# get user directory(arguments)
ifdef workspace
	USER_WORK_DIR=$(workspace)
else
	USER_WORK_DIR=$(shell pwd)
endif

#Base Tag.
# BASE_TAG=$(shell git rev-parse --short HEAD)
BASE_TAG=latest
COMMIT_SHA1=$(shell git rev-parse HEAD)

# test environment
ENVIRONMENT=$(env)
# get argument(database open port)
ENVIRONMENT=local
ifdef env
	ENVIRONMENT=$(env)
endif

#Docker Image Version
# php 8.0, nginx 1.19.7
#Docker Image Version
PHP_TAG=phpdockerio/php80-fpm:latest
HTTPD_TAG=nginx:1.19.7-alpine
DB_TAG=mysql:8.0.24

# Wokdir
WORK_DIR=/var/www/

# Image names for docker
BASE_IMAGE_NAME=boilerplate/proxy-php-base-$(ENVIRONMENT)
DB_IMAGE_NAME=boilerplate/db-$(ENVIRONMENT)

# Build args for Dockerfiles
BUILD_BASE_ARGS=--build-arg WORK_DIR=$(WORK_DIR) --build-arg ENVIRONMENT=$(ENVIRONMENT) --build-arg PHP_TAG=$(PHP_TAG)  --build-arg HTTPD_TAG=$(HTTPD_TAG)
BUILD_DB_ARGS=--build-arg IMAGE_NAME=$(DB_TAG) --build-arg PORT=$(DB_PORT)

# make images
all-images: base-image db-image

#Building base php image
base-image:
	@echo ":::Building Base Image"
	docker build --rm -f dockers/Base.Dockerfile $(BUILD_BASE_ARGS) -t $(BASE_IMAGE_NAME):$(BASE_TAG) .

db-image:
	echo ":::Building db image"
	docker build --rm -f dockers/DB.Dockerfile --platform=linux/x86_64 $(BUILD_DB_ARGS) -t $(DB_IMAGE_NAME) .
#Remove all images
rm-all-images:
	@echo ":::remove all images"
	-docker rmi $(DB_IMAGE_NAME) $(BASE_IMAGE_NAME):$(BASE_TAG)

#Up with rebuild
up-all:
	@echo ":::up all container"
	-docker-compose -f docker-compose-$(ENVIRONMENT).yml up  -d --build

#Up
up:
	@echo ":::up all container"
	-docker-compose -f docker-compose-$(ENVIRONMENT).yml up -d

#down
down:
	@echo ":::down all container"
	-docker-compose -f docker-compose-$(ENVIRONMENT).yml down

stop-all-cont:
	@echo ":::stop all container"
	-docker-compose -f docker-compose-$(ENVIRONMENT).yml stop

rm-all-cont:
	@echo ":::remove all container"
	-docker-compose -f docker-compose-$(ENVIRONMENT).yml rm
rm-all-vol:
	@echo ":::remove all volumn"
	-docker volume prune
rebuild-nocache:
	@echo ":::rebuild all image with no cache"
	-docker-compose -f docker-compose-$(ENVIRONMENT).yml build --no-cache
