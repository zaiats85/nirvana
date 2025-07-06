PHP_RUN ?= php
COMPOSER_BIN ?= /usr/bin/composer
COMPOSER_VENDOR_BIN ?= vendor/bin
COMPOSER_INSTALL_OPTIONS ?= --no-interaction --optimize-autoloader --no-scripts

include $(MAKE_RULES_PATH)/deprecated.mk

.PHONY: composer/auth
composer/auth: composer/auth/deprecated
	$(PHP_RUN) $(COMPOSER_BIN) config --working-dir=$(PROJECT_SOURCE) --auth http-basic.packeton.flagbit.cloud $(PACKETON_USERNAME) $(PACKETON_API_TOKEN)

.PHONY: composer/validate
composer/validate:
	$(PHP_RUN) $(COMPOSER_BIN) validate --working-dir=$(PROJECT_SOURCE) --no-check-all

.PHONY: composer/auth/%s
composer/auth/%s:
	$(PHP_RUN) $(COMPOSER_BIN) config --working-dir=$(PROJECT_SOURCE) --auth $(@F) $(COMPOSER_USERNAME) $(COMPOSER_TOKEN)

.PHONY: composer/install-development
composer/install-development:
	$(PHP_RUN) $(COMPOSER_BIN) install --working-dir=$(PROJECT_SOURCE) $(COMPOSER_INSTALL_OPTIONS)

.PHONY: composer/install-production
composer/install-production:
	$(PHP_RUN) $(COMPOSER_BIN) install --working-dir=$(PROJECT_SOURCE) $(COMPOSER_INSTALL_OPTIONS) --no-dev
