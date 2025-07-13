SHELL := /bin/bash
CONTAINER_MANAGER := docker
PROJECT_SOURCE := ./
PROJECT_NAME := nirvana
DATABASE_URL := mysql://app:app@mysql:3306/shopware
MAKE_RULES_PATH ?= ./.make-rules
GITHUB_USERNAME ?= $(shell stty -echo; read -p "GitHub username: " pwd; stty echo; echo $$pwd)
GHCR_TOKEN ?= $CR_PAT
#GHCR_TOKEN ?= $(shell stty -echo; read -p "GitHub personal access token: " pwd; stty echo; echo $$pwd)
#BW_COLLECTION ?= nirvana/demo
#BW_ITEM_COMPOSER_AUTH ?= _composer-auth

#SHOPWARE_CLI := bin/console
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

.PHONY: docker-login
docker-login:
	echo $(CR_PAT) | docker login ghcr.io -u USERNAME --password-stdin

#.PHONY: dep/tree/%
#dep/tree/%:
#	$(CONTAINER_MANAGER) run --rm \
#	  -e 'XDEBUG_MODE=off' \
#	  -v $$(pwd)/deploy.php:/deploy.php \
#	  -v $$(pwd)/.deployer:/.deployer \
#	  ghcr.io/flagbit/php/8.1/deployer-cli:2.0.0 \
#	  dep tree $(@F)