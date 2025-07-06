PHP_RUN ?= php

include $(MAKE_RULES_PATH)/composer.mk
include $(MAKE_RULES_PATH)/dev.mk

.PHONY: composer/install-production
composer/install-production: composer/validate

.PHONY: composer/install-development
composer/install-development: composer/validate

.PHONY: phpunit/analyze
phpunit/analyze:
	$(PHP_RUN) $(COMPOSER_VENDOR_BIN)/phpunit

.PHONY: phpstan/analyze
phpstan/analyze:
	$(PHP_RUN) $(COMPOSER_VENDOR_BIN)/phpstan analyse

.PHONY: phpspec/analyze
phpspec/analyze:
	$(PHP_RUN) $(COMPOSER_VENDOR_BIN)/phpspec run

.PHONY: php-cs-fixer/analyze
php-cs-fixer/analyze:
	$(PHP_RUN) $(COMPOSER_VENDOR_BIN)/php-cs-fixer fix --diff --dry-run

.PHONY: php-cs-fixer/fix
php-cs-fixer/fix:
	$(PHP_RUN) $(COMPOSER_VENDOR_BIN)/php-cs-fixer fix
