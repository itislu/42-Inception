MAKEFLAGS += --warn-undefined-variables

ENV_FILE := srcs/.env
include $(ENV_FILE)

DOCKER_COMPOSE := docker compose
export COMPOSE_FILE := srcs/docker-compose.yml

ifdef BONUS
export COMPOSE_PROFILES := bonus
endif

.PHONY: all
all: build
	@$(MAKE) --no-print-directory up

.PHONY: build
build: cert data-dirs
	$(DOCKER_COMPOSE) build

.PHONY: cert
cert:
	@if [ ! -f ${SSL_CERT_PATH} ] || [ ! -f ${SSL_KEY_PATH} ]; then \
		echo "Generating self-signed SSL certificate..."; \
		mkdir -p $(dir ${SSL_CERT_PATH} ${SSL_KEY_PATH}); \
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
			-out $(SSL_CERT_PATH) \
			-keyout $(SSL_KEY_PATH) \
			-subj "/CN=$(DOMAIN_NAME)"; \
	fi

.PHONE: data-dirs
data-dirs:
	@mkdir -p $(DB_DATA) $(WP_DATA)

.PHONY: up
up: cert data-dirs
	$(DOCKER_COMPOSE) up --pull never --detach

.PHONY: down
down:
	$(DOCKER_COMPOSE) down

.PHONY: start
start:
	$(DOCKER_COMPOSE) start

.PHONY: stop
stop:
	$(DOCKER_COMPOSE) stop

.PHONY: restart
restart:
	$(DOCKER_COMPOSE) restart

.PHONY: logs
logs:
	$(DOCKER_COMPOSE) logs --follow

.PHONY: ps
ps:
	$(DOCKER_COMPOSE) ps

.PHONY: clean
clean:
	$(DOCKER_COMPOSE) down --rmi all

.PHONY: fclean
fclean: clean
	$(DOCKER_COMPOSE) down --volumes
	-rm -rf $(DB_DATA) 2>/dev/null || sudo rm -rf $(DB_DATA)
	-rm -rf $(WP_DATA) 2>/dev/null || sudo rm -rf $(WP_DATA)
	-rmdir $(dir $(DB_DATA) $(WP_DATA)) 2>/dev/null

.PHONY: re
re: fclean
	@$(MAKE) --no-print-directory all
