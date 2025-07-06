SHOPWARE_APP_ENV ?= dev
SHOPWARE_CLI ?= bin/console
SHOPWARE_THEME_NAME ?= FlagbitBaseTheme

.PHONY: shopware/system/setup
shopware/system/setup:
	$(DOCKER_COMPOSE) exec -T \
	-e APP_ENV=$(SHOPWARE_APP_ENV) \
	-e DATABASE-URL=$(DATABASE_URL) \
	php-fpm $(SHOPWARE_CLI) system:setup --database-url="$(DATABASE_URL)" -n --force

.PHONY: shopware/system/install
shopware/system/install:
	$(PHP_EXEC) $(SHOPWARE_CLI) system:install --drop-database --create-database --basic-setup --no-assign-theme

.PHONY: shopware/elasticsearch/create-index
shopware/elasticsearch/create-index:
	$(PHP_EXEC) $(SHOPWARE_CLI) es:index --no-queue

.PHONY: shopware/plugin/refresh
shopware/plugin/refresh:
	$(PHP_EXEC) $(SHOPWARE_CLI) plugin:refresh > /dev/null

.PHONY: shopware/plugin/sync
shopware/plugin/sync: shopware/plugin/refresh
	$(PHP_EXEC) $(SHOPWARE_CLI) plugin:sync

.PHONY: shopware/config/sync
shopware/config/sync:
	$(PHP_EXEC) $(SHOPWARE_CLI) config:sync

.PHONY: shopware/build/js
shopware/build/js:
	$(DOCKER_COMPOSE) exec -T php-fpm bin/build-js.sh

.PHONY: shopware/theme/activate
shopware/theme/activate:
	printf "\n\nActivating the $(SHOPWARE_THEME_NAME):\n\n" \
	&& $(PHP_EXEC) $(SHOPWARE_CLI) theme:change $(SHOPWARE_THEME_NAME) --all --no-interaction