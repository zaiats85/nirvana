# Goals for commonly used code quality tools in PHP (qa)
PHP_RUN ?= php
COMPOSER_BIN_DIR ?= $$(composer config bin-dir)
PHPUNIT_COVERAGE_CLOVER ?= reports/coverage/coverage.xml
PHPUNIT_COVERAGE_HTML ?= reports/coverage
PHPUNIT_JUNIT_REPORT ?= reports/junit.xml
PHPSTAN_CONFIG ?= phpstan.neon
PHPCS_CONFIG ?= phpcs.xml
PHPSALM_CONFIG ?= psalm.xml
ECS_CONFIG ?= easy-coding-standard.php

.PHONY: php-cs-fixer/analyze
php-cs-fixer/analyze:
	$(PHP_RUN) $(COMPOSER_BIN_DIR)/php-cs-fixer fix --diff --dry-run

.PHONY: php-cs-fixer/fix
php-cs-fixer/fix:
	$(PHP_RUN) $(COMPOSER_BIN_DIR)/php-cs-fixer fix

.PHONY: easy-coding-standard/analyze
easy-coding-standard/analyze:
	$(PHP_RUN) $(COMPOSER_BIN_DIR)/ecs --config=$(ECS_CONFIG) check

.PHONY: easy-coding-standard/fix
easy-coding-standard/fix:
	$(PHP_RUN) $(COMPOSER_BIN_DIR)/ecs --config=$(ECS_CONFIG) --fix check

.PHONY: phpstan/analyze
phpstan/analyze:
	$(PHP_RUN) $(COMPOSER_BIN_DIR)/phpstan analyze --configuration $(PHPSTAN_CONFIG)

.PHONY: phpunit/analyze
phpunit/analyze:
	$(PHP_RUN) $(COMPOSER_BIN_DIR)/phpunit --coverage-clover $(PHPUNIT_COVERAGE) --coverage-html=$(PHPUNIT_COVERAGE_HTML) --log-junit $(PHPUNIT_JUNIT_REPORT)

.PHONY: phpcs/analyze
phpcs/analyze:
	$(PHP_RUN) $(COMPOSER_BIN_DIR)/phpcs --standard=$(PHPCS_CONFIG)

.PHONY: phpcs/fix
phpcs/fix:
	$(PHP_RUN) $(COMPOSER_BIN_DIR)/phpcbf --standard=$(PHPCS_CONFIG)

.PHONY: psalm/analyze
psalm/analyze:
	$(PHP_RUN) $(COMPOSER_BIN_DIR)/psalm --config=$(PHPSALM_CONFIG)
