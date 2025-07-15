SHELL := /bin/bash
CONTAINER_MANAGER := docker
PROJECT_SOURCE := ./shopware
PROJECT_NAME := nirvana
DATABASE_URL := mysql://app:app@mysql:3306/shopware
MAKE_RULES_PATH ?= ./.make-rules
GITHUB_USERNAME ?= $(shell stty -echo; read -p "GitHub username: " pwd; stty echo; echo $$pwd)
GHCR_TOKEN ?= $CR_PAT
COMPOSER_BIN ?= /usr/bin/composer
#GHCR_TOKEN ?= $(shell stty -echo; read -p "GitHub personal access token: " pwd; stty echo; echo $$pwd)
#BW_COLLECTION ?= nirvana/demo
#BW_ITEM_COMPOSER_AUTH ?= _composer-auth

SHOPWARE_CLI := shopware/bin/console
#SHOPWARE_APP_ENV ?= dev
#SHOPWARE_APP_URL ?= http://localhost:8080
#SHOPWARE_BASE_THEME_NAME := NirvanaBaseTheme
#SHOPWARE_THEME_NAME := Storefront
#SHOPWARE_ADMIN_USERNAME := admin
#SHOPWARE_ADMIN_PASSWORD := shopware
#
#MAILHOG_APP_URL ?= http://localhost:8025
#
#include $(MAKE_RULES_PATH)/shopware/6/project.mk

#.PHONY: dep/tree/%
#dep/tree/%:
#	$(CONTAINER_MANAGER) run --rm \
#	  -e 'XDEBUG_MODE=off' \
#	  -v $$(pwd)/deploy.php:/deploy.php \
#	  -v $$(pwd)/.deployer:/.deployer \
#	  ghcr.io/flagbit/php/8.1/deployer-cli:2.0.0 \
#	  dep tree $(@F)

DOCKER_COMPOSE := USER_ID=$$(id -u) docker-compose

.PHONY: start
start:
	$(DOCKER_COMPOSE) rm -f php-fpm \
	&& $(DOCKER_COMPOSE) up -d --remove-orphans

# Stop local environment
.PHONY: stop
stop:
	$(DOCKER_COMPOSE) stop

.PHONY: docker-login
docker-login:
	echo $(CR_PAT) | docker login ghcr.io -u USERNAME --password-stdin

.PHONY: ssh
ssh:
	$(DOCKER_COMPOSE) exec php-fpm bash

.PHONY: php-config
php-config:
	@echo -e "\033[1;35m=== PHP Configuration ===\033[0m"
	@$(DOCKER_COMPOSE) exec php-fpm php -r " \
		echo 'PHP Version: ' . phpversion() . \"\n\"; \
		echo 'SAPI: ' . php_sapi_name() . \"\n\"; \
		echo 'Memory Limit: ' . ini_get('memory_limit') . \"\n\"; \
		echo 'Max Execution Time: ' . ini_get('max_execution_time') . \"\n\"; \
		echo 'Post Max Size: ' . ini_get('post_max_size') . \"\n\"; \
		echo 'Upload Max Filesize: ' . ini_get('upload_max_filesize') . \"\n\"; \
		echo 'Max Input Vars: ' . ini_get('max_input_vars') . \"\n\"; \
		echo 'Timezone: ' . ini_get('date.timezone') . \"\n\"; \
		echo 'Error Reporting: ' . error_reporting() . \"\n\"; \
		echo 'Display Errors: ' . (ini_get('display_errors') ? 'On' : 'Off') . \"\n\"; \
		echo 'Log Errors: ' . (ini_get('log_errors') ? 'On' : 'Off') . \"\n\"; \
		echo 'OPcache Enabled: ' . (ini_get('opcache.enable') ? 'Yes' : 'No') . \"\n\"; \
		echo 'XDebug Loaded: ' . (extension_loaded('xdebug') ? 'Yes' : 'No') . \"\n\"; \
	"
	@echo -e "\033[1;31m=== Memory Usage ===\033[0m"
	@$(DOCKER_COMPOSE) exec php-fpm php -r " \
		echo 'Current Usage: ' . number_format(memory_get_usage(true)) . ' bytes' . \"\n\"; \
        echo 'Peak Usage: ' . number_format(memory_get_peak_usage(true)) . ' bytes' . \"\n\"; \
        echo 'Node Version: ' . trim(shell_exec('node -v')) . \"\n\"; \
        echo 'NPM Version: ' . trim(shell_exec('npm -v 2>/dev/null')) . \"\n\"; \
        echo 'Container User ID: ' . trim(shell_exec('id -u')) . \"\n\"; \
	"

# Create new Shopware project
.PHONY: create-shopware
create-shopware:
	export USER_ID=1000
	printf "x\n" | $(DOCKER_COMPOSE) run --rm -T php-fpm composer create-project shopware/production:6.7.0.1 shopware
	$(DOCKER_COMPOSE) run --rm -T php-fpm bash -c 'cd shopware && cat > .env.local << EOF APP_ENV=dev DATABASE_URL=mysql://app:app@mysql:3306/shopware APP_URL=https://localhost:8443 EOF'

.PHONY: shopware/system/install
shopware/system/install:
	$(DOCKER_COMPOSE) exec -T php-fpm php $(SHOPWARE_CLI) system:install --drop-database --create-database --basic-setup --no-assign-theme --force
