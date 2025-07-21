#new make file
.PHONY: start stop logs db-import ssh help enable-xdebug disable-xdebug build-app db-export uninstall-plugins search-index-on search-index-off

# Primary services
APP_SERVER = app_server
MYSQL = mysql
ELASTICSEARCH = elasticsearch
MAILHOG = mailhog
ADMINER = adminer

help:
	@echo -e "\033[1;38;5;196m  ____   ____    ___   ____    _  _____  _"
	@echo -e "\033[1;38;5;196m |  _ \ |  _ \  / _ \ |  _ \  / \|_   _|/ \\"
	@echo -e "\033[1;38;5;196m | |_) || |_) || | | || | | |/ _ \ | | / _ \\"
	@echo -e "\033[1;38;5;196m |  __/ |  _ < | |_| || |_| / ___ \| |/ ___ \\"
	@echo -e "\033[1;38;5;196m |_|    |_| \_\ \___/ |____/_/   \_\_/_/   \_\\"
	@echo -e "\033[0m"
	@echo "Available commands:"
	@echo "PROJECT SETUP:"
	@echo -e "  \033[32mmake init\033[0m                     - Initialize complete project setup"
	@echo -e "  \033[32mmake build\033[0m                    - Build local environment"
	@echo -e "  \033[32mmake build-app\033[0m                - Build application"
	@echo -e "  \033[32mmake start\033[0m                    - Start local environment"
	@echo -e "  \033[32mmake stop\033[0m                     - Stop containers (do not delete)"
	@echo -e "  \033[32mmake down\033[0m                     - Stop and remove containers"
	@echo "DEVELOPMENT:"
	@echo -e "  \033[32mmake ssh\033[0m                      - SSH into app server"
	@echo -e "  \033[32mmake service/ssh service=NAME\033[0m         - SSH into specific service (nginx, mailhog, es, db)"
	@echo -e "  \033[32mmake logs\033[0m                     - View logs for all services"
	@echo -e "  \033[32mmake logs service=NAME\033[0m        - View logs for specific service"
	@echo -e "  \033[32mmake enable-xdebug\033[0m            - Enable Xdebug and restart containers"
	@echo -e "  \033[32mmake disable-xdebug\033[0m           - Disable Xdebug and restart containers"
	@echo "DATABASE:"
	@echo -e "  \033[32mmake db-import file=PATH\033[0m      - Import database from file"
	@echo -e "  \033[32mmake db-export\033[0m                - Export database to files/db_dumps"
	@echo "COMPOSER:"
	@echo -e "  \033[32mmake composer/auth\033[0m            - Configure composer authentication"
	@echo -e "  \033[32mmake composer/install\033[0m         - Install dependencies"
	@echo -e "  \033[32mmake composer/update\033[0m          - Update dependencies"
	@echo "QUALITY ASSURANCE:"
	@echo -e "  \033[32mmake phpcs/fix\033[0m                - Fix PHP coding standards"
	@echo -e "  \033[32mmake php-cs-fixer/fix\033[0m         - Run PHP CS Fixer"
	@echo -e "  \033[32mmake phpstan/analyze\033[0m          - Run PHPStan analysis"
	@echo -e "  \033[32mmake psalm/analyze\033[0m            - Run Psalm analysis"
	@echo -e "  \033[32mmake phpunit/test\033[0m             - Run PHPUnit tests"
	@echo "UTILITIES:"
	@echo -e "  \033[32mmake search-index-on\033[0m          - Enable search engine indexing (index,follow)"
	@echo -e "  \033[32mmake search-index-off\033[0m         - Disable search engine indexing (noindex,nofollow)"
	@echo -e "  \033[32mmake setup-ssl\033[0m                - Setup SSL certificates"
	@echo -e "  \033[32mmake php-config\033[0m               - Show PHP configuration"
	@echo -e "  \033[32mmake check-preconditions\033[0m      - Check system requirements"

# Logs with optional service parameter
logs:
	@if [ -z "$(service)" ]; then \
		docker compose logs -f; \
	else \
		docker compose logs -f $(service); \
	fi

# SSH with optional service parameter
service/ssh:
	@if [ -z "$(service)" ]; then \
		docker compose exec $(APP_SERVER) bash; \
	else \
		docker compose exec $(service) bash; \
	fi

# Database import
.PHONY: db-import

# Check and install PV if not exists
check-pv:
	@which pv >/dev/null 2>&1 || (echo "Installing pv..." && sudo apt-get update && sudo apt-get install -y pv)

# Database import with file path as argument
db-import: check-pv
	@if [ -z "$(file)" ]; then \
		echo "Usage: make db-import file=/path/to/your/database/dump.gz"; \
		exit 1; \
	fi
	@if [ ! -f "$(file)" ]; then \
		echo "Error: File $(file) does not exist."; \
		exit 1; \
	fi
	@echo "Importing database from $(file)..."
	@pv "$(file)" | gunzip | docker compose  exec -T mysql mysql -uroot -proot shopware

# Database export
db-export:
	@mkdir -p files/db_dumps
	@timestamp=$$(date +"%Y%m%d_%H%M%S"); \
	filename="shopware_backup_$${timestamp}.sql.gz"; \
	echo "Exporting database to files/db_dumps/$${filename}"; \
	docker compose  exec $(MYSQL) mysqldump -uroot -proot shopware --single-transaction --skip-lock-tables --no-tablespaces | gzip | pv > files/db_dumps/$${filename}

# Enable Xdebug
enable-xdebug:
	@echo "Enabling Xdebug..."
	@if [ -f .env ]; then \
		grep -v "^XDEBUG_MODE=" .env > .env.tmp && mv .env.tmp .env || true; \
	fi
	@echo "XDEBUG_MODE=debug" >> .env
	@echo "Restarting containers..."
	@$(MAKE) stop
	@$(MAKE) start
	@echo "Xdebug enabled and containers restarted."

# Disable Xdebug
disable-xdebug:
	@echo "Disabling Xdebug..."
	@if [ -f .env ]; then \
		grep -v "^XDEBUG_MODE=" .env > .env.tmp && mv .env.tmp .env || true; \
	fi
	@echo "XDEBUG_MODE=off" >> .env
	@echo "Restarting containers..."
	@$(MAKE) stop
	@$(MAKE) start
	@echo "Xdebug disabled and containers restarted."

# Enable search engine indexing
# Enable search engine indexing with cache clear
search-index-on:
	@echo "Enabling search engine indexing..."
	@if [ -f .env ]; then \
		grep -v "^SEARCH_INDEX_MODE=" .env > .env.tmp && mv .env.tmp .env || true; \
	fi
	@echo "SEARCH_INDEX_MODE=index" >> .env
	@docker compose exec $(APP_SERVER) php bin/console cache:clear
	@echo "Search engine indexing enabled (index,follow) and cache cleared."

# Disable search engine indexing
search-index-off:
	@echo "Disabling search engine indexing..."
	@if [ -f .env ]; then \
		grep -v "^SEARCH_INDEX_MODE=" .env > .env.tmp && mv .env.tmp .env || true; \
	fi
	@echo "SEARCH_INDEX_MODE=noindex" >> .env
	@docker compose exec $(APP_SERVER) php bin/console cache:clear
	@echo "Search engine indexing disabled (noindex,nofollow)."
#end new make file

SHELL := /bin/bash
CONTAINER_MANAGER := docker
PROJECT_SOURCE := ./
PROJECT_NAME := nirvana
DATABASE_URL := mysql://app:app@mysql:3306/nirvana
MAKE_RULES_PATH ?= ./.make-rules
GITHUB_USERNAME ?= $(shell stty -echo; read -p "GitHub username: " pwd; stty echo; echo $$pwd)
GHCR_TOKEN ?= $CR_PAT
COMPOSER_BIN ?= /usr/bin/composer
#GHCR_TOKEN ?= $(shell stty -echo; read -p "GitHub personal access token: " pwd; stty echo; echo $$pwd)
#BW_COLLECTION ?= nirvana/demo
#BW_ITEM_COMPOSER_AUTH ?= _composer-auth

SHOPWARE_APP_ENV ?= dev
SHOPWARE_CLI := shopware/bin/console
SHOPWARE_LOCAL_DIR := shopware;
SHOPWARE_APP_URL ?= http://localhost:8080
SHOPWARE_BASE_THEME_NAME := ProdataBaseTheme
SHOPWARE_THEME_NAME := Storefront
SHOPWARE_ADMIN_USERNAME := admin
SHOPWARE_ADMIN_PASSWORD := shopware
MAILHOG_APP_URL ?= http://localhost:8025

include $(MAKE_RULES_PATH)/shopware/6/project.mk

#.PHONY: dep/tree/%
#dep/tree/%:
#	$(CONTAINER_MANAGER) run --rm \
#	  -e 'XDEBUG_MODE=off' \
#	  -v $$(pwd)/deploy.php:/deploy.php \
#	  -v $$(pwd)/.deployer:/.deployer \
#	  ghcr.io/flagbit/php/8.1/deployer-cli:2.0.0 \
#	  dep tree $(@F)
