BW_ITEM_COMPOSER_AUTH ?= COMPOSER_AUTH
BW_USERNAME ?=
BW_PASSWORD ?=
BW_FILENAME ?=

define ERROR_MESSAGE_BW_ENVIRONMENT
ENVIRONMENT VARIABLES FOR BITWARDEN MISSING!
============================================

For a smoother workflow we now rely on 2 environment variables beeing set on
your system. If it is unclear how to do this, please consult your shells manpage
(typically 'man bash' or 'man zsh') on how to set environment variables and also
the README of this repository (https://github.com/flagbit/make-rules/) for 
further recommendations.
endef

.ONESHELL: auth.json

.PHONY: bitwarden/file/get/force/%
bitwarden/file/get/force/%:
	rm "$(BW_FILENAME)"; \
	$(MAKE) "$(BW_FILENAME)";

.PHONY: bitwarden/file/get/%
bitwarden/file/get/%:
	@if [[ -z "$${CI}" ]]; then \
		if [ ! -f "$(BW_FILENAME)" ]; then \
		    if [ -z "$(BW_USERNAME)" ] || [ -z "$(BW_PASSWORD)" ]; then \
				echo "" ; \
				echo -e "\033[0;33m$(ERROR_MESSAGE_BW_ENVIRONMENT)" ; \
				echo "" ; \
				echo -e "\033[0;31mPlease set BW_USERNAME environment variable and use your bitwarden username as value!" ; \
				echo "" ;
				echo -e "\033[0;31mPlease set BW_PASSWORD environment variable and use your bitwarden password as value!" ; \
				echo "" ; \
				exit 1 ; \
			fi; \
			bw_status=$$(bw status 2> /dev/null|jq -r '.status') ; \
			if [ "$$bw_status" == "unauthenticated" ]; then \
			echo "logging in now..." ; \
			export BW_SESSION="$$(bw login --raw "$(BW_USERNAME)" "$(BW_PASSWORD)")"; \
			fi; \
			export BW_SESSION=$$(bw unlock --raw "$(BW_PASSWORD)"); \
			collection_id=$$(bw list collections | jq --raw-output '.[] | select(.name=="'"$(BW_COLLECTION)"'") | .id'); \
			if [[ -z "$${collection_id}" ]]; then \
				printf 'Collection id not found for name %s\n' $(BW_COLLECTION); \
				exit 1; \
			else \
				printf 'Collection id found for %s: %s\n' $(BW_COLLECTION) "$${collection_id}"; \
			fi; \
			item=$$(bw list items | jq --raw-output '.[] | select(.collectionIds | index("'"$${collection_id}"'")) | select (.name=="$(@F)") | .notes') ; \
			if [[ -z "$${item}" ]]; then \
				printf 'Collection item with name %s not found.\n' "$(@F)"; \
				exit 1; \
			else \
				printf 'Collection item with name %s found.\n' "$(@F)"; \
				mkdir -p "$$(dirname $(BW_FILENAME))"
				echo "$${item}" > "$(BW_FILENAME)"; \
			fi; \
		fi; \
	fi

.PHONY: auth.json
auth.json: BW_FILENAME = auth.json
auth.json: bitwarden/file/get/$(BW_ITEM_COMPOSER_AUTH)

.PHONY: auth.json/force
auth.json/force: BW_FILENAME = auth.json
auth.json/force: bitwarden/file/get/force/$(BW_ITEM_COMPOSER_AUTH)
