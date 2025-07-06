APPLICATION_TYPE ?= shopware
APPLICATION_VERSION ?= 6.4
APPLICATION_ENVIRONMENT ?= production
PODNAME ?= shopware
IMAGE_TAG ?= 0.1.0
CONTAINER_MANAGER ?= podman

IMAGE_VERSION_MYSQL ?= 5

MYSQL_ROOT_PASSWORD ?= root
MYSQL_PASSWORD ?= shopware
MYSQL_DATABASE ?= shopware
MYSQL_USER ?= shopware

SHOPWARE_APP_ENV ?= dev
SHOPWARE_APP_URL ?= http://shopware.local:8080
SHOPWARE_BLUEGREEN ?= 1
SHOPWARE_SHOP_NAME ?= testing
SHOPWARE_SHOP_EMAIL ?= shopware@flagbit.de
SHOPWARE_SHOP_LOCALE ?= de_DE
SHOPWARE_SHOP_CURRENCY ?= EUR

-include $(MAKE_RULES_PATH)/ghcr.mk

#
# POD
# ==============================================================================
pod/init: pod/create container/attach/nginx container/attach/php-fpm container/attach/mysql
	sleep 1

pod/create:
	$(CONTAINER_MANAGER) pod create --name $(PODNAME) --userns keep-id --publish 8080:8080 --publish 3306:3306

pod/stop:
	$(CONTAINER_MANAGER) pod stop $(PODNAME)

pod/start:
	$(CONTAINER_MANAGER) pod start $(PODNAME)

pod/rm:
	$(CONTAINER_MANAGER) pod rm $(PODNAME)

pod/rebuild: pod/stop pod/rm pod/init

container/attach/nginx:
	$(CONTAINER_MANAGER) run -d --user $$UID --name=$(PODNAME)_$(@F) --pod=$(PODNAME) \
	-v $$(pwd):/srv/www:Z \
	ghcr.io/flagbit/$(APPLICATION_TYPE)/$(APPLICATION_VERSION)/$(@F)/$(APPLICATION_ENVIRONMENT):0.1.0

container/attach/php-fpm:
	$(CONTAINER_MANAGER) run -d --user $$UID --name=$(PODNAME)_$(@F) --pod=$(PODNAME) \
	-v $$(pwd):/srv/www:Z \
	-e DATABASE-URL="mysql://root:$(MYSQL_ROOT_PASSWORD)@127.0.0.1:3306/$(MYSQL_DATABASE)" \
	-e ENV="$(SHOPWARE_APP_ENV)" \
	-e APP-ENV="$(SHOPWARE_APP_ENV)" \
	-e APP-URL="$(SHOPWARE_APP_URL)" \
	-e BLUE-GREEN="$(SHOPWARE_BLUEGREEN)" \
	-e SHOP-NAME="$(SHOPWARE_SHOP_NAME)" \
	-e SHOP-EMAIL="$(SHOPWARE_SHOP_EMAIL)" \
	-e SHOP-LOCALE="$(SHOPWARE_SHOP_LOCALE)" \
	-e SHOP-CURRENCY="$(SHOPWARE_SHOP_CURRENCY)" \
	ghcr.io/flagbit/$(APPLICATION_TYPE)/$(APPLICATION_VERSION)/$(@F)/$(APPLICATION_ENVIRONMENT):0.1.0

container/attach/mysql:
	$(CONTAINER_MANAGER) run -d --user $$UID --name=$(PODNAME)_$(@F) --pod=$(PODNAME) \
	-e MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) \
	-e MYSQL_PASSWORD=$(MYSQL_PASSWORD) \
	-e MYSQL_DATABASE= $(MYSQL_DATABASE\
	-e MYSQL_USER=$(MYSQL_USER) \
	docker.io/library/mysql:$(IMAGE_VERSION_MYSQL)

container/attach/%:
	$(CONTAINER_MANAGER) run -d --user $$UID --name=$(PODNAME)_$(@F) --pod=$(PODNAME) $(FQIN)

#
# SHOPWARE
# ==============================================================================
shopware/store/setup:
	$(CONTAINER_MANAGER) exec --user $$UID -it $(PODNAME)_php-fpm bin/console system:install --basic-setup --drop-database --no-interaction -f \
	&& $(CONTAINER_MANAGER) exec --user $$UID -it $(PODNAME)_php-fpm bin/console system:setup --no-interaction -f \
	&& $(CONTAINER_MANAGER) exec --user $$UID -it $(PODNAME)_php-fpm bin/console sales-channel:create:storefront --url="$(SHOPWARE_APP_URL)" \
	&& $(CONTAINER_MANAGER) exec -e APP_ENV=prod --user $$UID -it $(PODNAME)_php-fpm bin/console framework:demodata

shopware/store/install:
	$(CONTAINER_MANAGER) exec --user 0 -it $(PODNAME)_php-fpm bin/console system:install --basic-setup --drop-database --no-interaction -f