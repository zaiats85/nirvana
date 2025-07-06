# make-rules for podman

## Example Makefile using these Rules

```make
PODNAME ?= magento-project

APPLICATION_TYPE ?= magento
APPLICATION_VERSION ?= 2.4
APPLICATION_ENVIRONMENT ?= production

IMAGE_VERSION_NGINX ?= 0.1.0
IMAGE_VERSION_PHP-FPM ?= 0.1.0
IMAGE_VERSION_MARIADB ?= 10.4
IMAGE_VERSION_ELASTICSEARCH ?= 7.10.1
IMAGE_VERSION_REDIS ?= 6-alpine
IMAGE_VERSION_VARNISH ?= 6.5
IMAGE_VERSION_RABBITMQ ?= 3.8-alpine

pod/init:
	$(MAKE) pod/create ; \
	$(MAKE) pod/attach/nginx ; \
	$(MAKE) pod/attach/php-fpm ; \
	$(MAKE) pod/attach/mariadb; \
	$(MAKE) pod/attach/elasticsearch ; \
	$(MAKE) pod/attach/redis; \
	$(MAKE) pod/attach/varnish FQIN=docker.io/library/varnish:$(IMAGE_VERSION_VARNISH) ; \
	$(MAKE) pod/attach/rabbitmq FQIN=docker.io/library/rabbitmq:$(IMAGE_VERSION_RABBITMQ)

pod/attach/nginx:
	$(CONTAINER_MANAGER) run -d --user $$UID --name=$(PODNAME)_$(@F) --pod=$(PODNAME) \
	-v $$(pwd):/srv/www \
	-v $$(pwd)/.container/nginx/default.conf:/etc/nginx/conf.d/default.conf \
	ghcr.io/flagbit/$(@F)/$(APPLICATION_TYPE)/$(APPLICATION_VERSION)/$(APPLICATION_ENVIRONMENT):$(IMAGE_VERSION_NGINX)

pod/attach/php-fpm:
	$(CONTAINER_MANAGER) run -d --user $$UID --name=$(PODNAME)_$(@F) --pod=$(PODNAME) \
	-v $$(pwd):/srv/www \
	ghcr.io/flagbit/$(@F)/$(APPLICATION_TYPE)/$(APPLICATION_VERSION)/$(APPLICATION_ENVIRONMENT):$(IMAGE_VERSION_PHP-FPM)

pod/attach/mariadb:
	$(CONTAINER_MANAGER) run -d --user $$UID --name=$(PODNAME)_$(@F) --pod=$(PODNAME) \
	-v $$(pwd)/volumes/mariadb:/var/lib/mysql \
	-e MYSQL_ROOT_PASSWORD=root \
	-e MYSQL_PASSWORD=magento \
	-e MYSQL_DATABASE=magento \
	-e MYSQL_USER=magento \
	docker.io/library/mariadb:$(IMAGE_VERSION_MARIADB)

pod/attach/elasticsearch:
	$(CONTAINER_MANAGER) run -d --user $$UID --name=$(PODNAME)_$(@F) --pod=$(PODNAME) \
	-v $$(pwd)/volumes/elasticsearch:/usr/share/elasticsearch/data \
	-e discovery.type=single-node \
	docker.io/library/elasticsearch:$(IMAGE_VERSION_ELASTICSEARCH)

pod/attach/redis:
	$(CONTAINER_MANAGER) run -d --user $$UID --name=$(PODNAME)_$(@F) --pod=$(PODNAME) \
	-v $$(pwd)/volumes/redis:/data \
	docker.io/library/redis:$(IMAGE_VERSION_REDIS)
```