GHCR_TOKEN ?= $(GITHUB_K8S_TOKEN)
FQIN ?= ghcr.io/$(GHCR_ACCOUNT)/$(IMAGE_NAME)

include $(MAKE_RULES_PATH)/oci.mk
include $(MAKE_RULES_PATH)/deprecated.mk


.PHONY: ghcr/login
ghcr/login:
	if [ -z "$(GITHUB_USERNAME)" ] || [ -z "$(GHCR_TOKEN)" ]; then \
		echo "" ; \
		echo -e "\033[0;33mENVIRONMENT VARIABLES FOR GITHUB MISSING!" ; \
		echo "" ; \
		echo -e "\033[0;31mPlease set GITHUB_USERNAME environment variable and use your github username as value!" ; \
		echo -e "\033[0;31mPlease set GHCR_TOKEN environment variable and use a github personal access token with access to packages as value!" ; \
		echo -e "\033[0;0m" ; \
		exit 1 ; \
	fi; \
	echo $(GHCR_TOKEN)|$(CONTAINER_MANAGER) login ghcr.io -u $(GITHUB_USERNAME) --password-stdin

# Backwards compatibility
.PHONY: ghcr/clean
ghcr/clean: ghcr/clean/deprecated oci/clean

.PHONY: ghcr/build
ghcr/build: ghcr/build/deprecated oci/build

.PHONY: ghcr/push
ghcr/push: ghcr/push/deprecated oci/push

.PHONY: ghcr/push-commit
ghcr/push-commit: ghcr/push-commit/deprecated oci/push-commit

.PHONY: ghcr/push-release
ghcr/push-release: ghcr/push-release/deprecated oci/push-release
