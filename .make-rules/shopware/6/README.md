## How to setup a local project with this?

Pretty straightforward.. You just have to set some variables, and include
`$(MAKE_RULES_PATH)/shopware/6/project.mk` in your local Makefile.

An Example could look like this:

```make
SHELL := /bin/bash
CONTAINER_MANAGER := docker
PROJECT_SOURCE := ./
DATABASE_URL := mysql://app:app@mysql:3306/shopware
MAKE_RULES_PATH ?= ./.make-rules
GITHUB_USERNAME ?= $(shell stty -echo; read -p "GitHub username: " pwd; stty echo; echo $$pwd)
GHCR_TOKEN ?= $(shell stty -echo; read -p "GitHub personal access token: " pwd; stty echo; echo $$pwd)
# ID for #foodspring-internal flagbit slack channel
SLACK_CHANNEL ?= C03ACQHBPMJ
BW_COLLECTION ?= customer/foodspring

SHOPWARE_CLI := bin/console
SHOPWARE_APP_ENV ?= dev
SHOPWARE_APP_URL ?= http://localhost:8080
SHOPWARE_THEME_NAME := FoodspringTheme
SHOPWARE_DB_USERNAME := admin
SHOPWARE_DB_PASSWORD := shopware

MAILHOG_APP_URL ?= http://localhost:8025

include $(MAKE_RULES_PATH)/shopware/6/project.mk
```

## How can somebody that has not access to Bitwarden setup the project?

There is only on make-recipe that is really using bitwarden, and that is
`vendor`. To get rid of this, the (probably external) developer without access
to bitwarden can simply override the vendor-recipe in its local Makefile,
removing the `auth.json` dependency from `vendor`.

Based on the Example above, that would look like this:

```make
SHELL := /bin/bash
CONTAINER_MANAGER := docker
PROJECT_SOURCE := ./
DATABASE_URL := mysql://app:app@mysql:3306/shopware
MAKE_RULES_PATH ?= ./.make-rules
GITHUB_USERNAME ?= $(shell stty -echo; read -p "GitHub username: " pwd; stty echo; echo $$pwd)
GHCR_TOKEN ?= $(shell stty -echo; read -p "GitHub personal access token: " pwd; stty echo; echo $$pwd)
# ID for #foodspring-internal flagbit slack channel
SLACK_CHANNEL ?= C03ACQHBPMJ
BW_COLLECTION ?= customer/foodspring

SHOPWARE_CLI := bin/console
SHOPWARE_APP_ENV ?= dev
SHOPWARE_APP_URL ?= http://localhost:8080
SHOPWARE_THEME_NAME := FoodspringTheme
SHOPWARE_DB_USERNAME := admin
SHOPWARE_DB_PASSWORD := shopware

MAILHOG_APP_URL ?= http://localhost:8025

include $(MAKE_RULES_PATH)/shopware/6/project.mk

.PHONY: vendor
vendor: composer/install-development
```
