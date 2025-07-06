COMPOSE_FILE ?= -f docker-compose.yml
SHELL_CONTAINER ?= php-cli

.PHONY: up
up:
	$(DOCKER_COMPOSE_BIN) $(COMPOSE_FILE) up -d --build

.PHONY: down
down:
	$(DOCKER_COMPOSE_BIN) $(COMPOSE_FILE) down -v

.PHONY: stop
stop:
	$(DOCKER_COMPOSE_BIN) $(COMPOSE_FILE) stop

.PHONY: ssh
ssh:
	$(DOCKER_COMPOSE_BIN) $(COMPOSE_FILE) run $(SHELL_CONTAINER) $(SHELL)
