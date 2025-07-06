include $(MAKE_RULES_PATH)/composer.mk
#include $(MAKE_RULES_PATH)/bitwarden.mk

.PHONY: composer/install-production
composer/install-production: composer/validate

.PHONY: composer/install-development
composer/install-development: composer/validate

.PHONY: check-preconditions
check-preconditions:
	@if [[ -z "$${CI}" ]]; then \
  		make command-exists-or-exit/git; \
  		make command-exists-or-exit/docker; \
  		make command-exists-or-exit/docker-compose; \
  		make command-exists-or-exit/bw; \
  		make command-exists-or-exit/jq; \
	fi

.PHONY: command-exists-or-exit/%
command-exists-or-exit/%:
	@if ! command -v $(@F) >/dev/null 2>&1; then \
		printf 'Command %s is required but not installed. Aborting.\n' $(@F); \
		exit 1; \
	fi
