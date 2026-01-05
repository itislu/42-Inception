ENV_FILE := srcs/.env
include $(ENV_FILE)
export DOMAIN_NAME

COMPOSE_FILE := srcs/docker-compose.yml
DATA_DIR     := $(HOME)/data
WP_DATA      := $(DATA_DIR)/wordpress
DB_DATA      := $(DATA_DIR)/mariadb
SECRETS_DIR  := secrets
SSL_CERT     := $(SECRETS_DIR)/ssl_cert.pem
SSL_KEY      := $(SECRETS_DIR)/ssl_key.pem

.PHONY: all
all: build
	@$(MAKE) --no-print-directory up

.PHONY: build
build: cert
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	docker compose --file $(COMPOSE_FILE) build

# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu#step-1-creating-the-tls-certificate
.PHONY: cert
cert:
	@if [ ! -f $(SSL_CERT) ] || [ ! -f $(SSL_KEY) ]; then \
		echo "Generating self-signed SSL certificate..."; \
		mkdir -p $(dir $(SSL_CERT) $(SSL_KEY)); \
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
			-out $(SSL_CERT) \
			-keyout $(SSL_KEY) \
			-subj "/CN=$(DOMAIN_NAME)"; \
	fi

.PHONY: up
up: cert
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	docker compose --file $(COMPOSE_FILE) up --pull never --detach

.PHONY: down
down:
	docker compose --file $(COMPOSE_FILE) down

.PHONY: start
start:
	docker compose --file $(COMPOSE_FILE) start

.PHONY: stop
stop:
	docker compose --file $(COMPOSE_FILE) stop

.PHONY: restart
restart:
	docker compose --file $(COMPOSE_FILE) restart

.PHONY: logs
logs:
	docker compose --file $(COMPOSE_FILE) logs --follow

.PHONY: ps
ps:
	docker compose --file $(COMPOSE_FILE) ps

.PHONY: clean
clean: down
	-docker rmi mariadb nginx wordpress

.PHONY: fclean
fclean:
	-@$(MAKE) --no-print-directory clean
	-docker volume rm srcs_mariadb-data srcs_wordpress-data
	-rm -rf $(WP_DATA) 2>/dev/null || sudo rm -rf $(WP_DATA)
	-rm -rf $(DB_DATA) 2>/dev/null || sudo rm -rf $(DB_DATA)
	-rmdir $(DATA_DIR) 2>/dev/null

.PHONY: re
re: fclean
	@$(MAKE) --no-print-directory all
