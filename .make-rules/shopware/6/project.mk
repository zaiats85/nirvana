SHELL := /bin/bash
CONTAINER_MANAGER := docker
PROJECT_SOURCE := ./
DATABASE_URL := mysql://app:app@mysql:3306/shopware
MAKE_RULES_PATH ?= ./.make-rules

SHOPWARE_APP_URL ?= http://localhost:8080
SHOPWARE_DB_USERNAME := admin
SHOPWARE_DB_PASSWORD := shopware

MAILHOG_APP_URL ?= http://localhost:8025

ifeq (, $(shell which docker-compose))
  DOCKER_COMPOSE :=
  PHP_RUN := php
  PHP_EXEC := php
else
  DOCKER_COMPOSE := USER_ID=$$(id -u) docker-compose
  PHP_RUN := $(DOCKER_COMPOSE) run -T --rm php-fpm php
  PHP_EXEC := $(DOCKER_COMPOSE) exec -T php-fpm php
  MYSQL_RUN := $(DOCKER_COMPOSE) exec -T mysql mysql -uroot -proot shopware
endif

-include $(MAKE_RULES_PATH)/ssh.mk
#-include $(MAKE_RULES_PATH)/slack.mk
#-include $(MAKE_RULES_PATH)/deployer7.mk
#-include $(MAKE_RULES_PATH)/ghcr.mk
-include $(MAKE_RULES_PATH)/mysql.mk
#-include $(MAKE_RULES_PATH)/grafana.mk
#-include $(MAKE_RULES_PATH)/phpqa.mk
-include $(MAKE_RULES_PATH)/shopware/6/shopware.mk
-include $(MAKE_RULES_PATH)/shopware/6/utilities.mk

.PHONY: vendor
vendor: composer/install-development

# Build local environment
.PHONY: build
build: check-preconditions docker-compose.override.yml
	$(DOCKER_COMPOSE) build

# Start local environment
.PHONY: start
start: build
	$(DOCKER_COMPOSE) rm -f php-fpm \
	&& $(DOCKER_COMPOSE) up -d --remove-orphans

# Stop local environment
.PHONY: stop
stop:
	$(DOCKER_COMPOSE) stop

.PHONY: mysql/wait
mysql/wait:
	# sleep is needed to wait for mysql (!)
	$(DOCKER_COMPOSE) exec php-fpm echo "Ne"
	$(DOCKER_COMPOSE) exec -T -e DATABASE_URL="" -e APP_ENV=$(SHOPWARE_APP_ENV) -e DATABASE-URL=$(DATABASE_URL) php-fpm bash -c 'while ! /usr/bin/mariadb-admin status -h mysql -uroot -proot --ssl=0; do sleep 1; done'

.PHONY: info/services
info/services:
	printf "Start browsing:\n" \
	&& printf "  Shopware storefront: $(SHOPWARE_APP_URL)\n" \
	&& printf "  Shopware backend: $(SHOPWARE_APP_URL)/admin (username=$(SHOPWARE_DB_USERNAME) and password=$(SHOPWARE_DB_PASSWORD))\n" \
	&& printf "  Mailhog: $(MAILHOG_APP_URL)\n"

.PHONY: init
init: start vendor mysql/wait shopware/system/setup shopware/system/install shopware/elasticsearch/create-index shopware/build/js shopware/theme/activate info/services

.PHONY: down
down:
	$(DOCKER_COMPOSE) down -v

.PHONY: ssh
ssh:
	$(DOCKER_COMPOSE) exec php-fpm bash

.PHONY: %/analyze
%/analyze:
	$(PHP_RUN) /usr/bin/composer run-script -d . $(@D)

.PHONY: lint/commit
lint/commit:
	commitlint -g commitlint.config.js --from=$$(git rev-parse remotes/origin/$(GITHUB_BASE_REF))

# creates docker-compose.override.yml from docker-compose.override.yml.dist if CI env variable is not set
docker-compose.override.yml:
	@if [ -z "$$CI" ]; then \
  		cp docker-compose.override.yml.dist docker-compose.override.yml; \
	fi
