PHP_RUN ?= php

-include $(MAKE_RULES_PATH)/dev.mk
-include $(MAKE_RULES_PATH)/composer.mk
-include $(MAKE_RULES_PATH)/mysql.mk
-include $(MAKE_RULES_PATH)/phpqa.mk

# Common Symfony environment controls
.PHONY: cache/clear
cache/clear:
	$(PHP_RUN) bin/console cache:clear

.PHONY: doctrine/migrate
doctrine/migrate:
	$(PHP_RUN) bin/console doctrine:migrations:migrate -n

.PHONY: doctrine/update-schema
doctrine/update-schema:
	$(PHP_RUN) bin/console doctrine:schema:update

.PHONY: make/migration
make/migration:
	$(PHP_RUN) bin/console make:migration

# Standardized set for Symfony quality assurance
.PHONY: qa
qa: composer/validate php-cs-fixer/analyze phpstan/analyze phpunit/analyze
