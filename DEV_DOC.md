# Developer Documentation

## Repository Layout
- `srcs/docker-compose.yml`: stack definition (networks, volumes, secrets)
- `srcs/requirements/{mariadb,wordpress,nginx}/`: Dockerfiles + configs + entrypoints
- `srcs/requirements/bonus/{adminer,cadvisor}/`: bonus service files
- `srcs/.env.template`: variables you must fill (create `srcs/.env`)
- `secrets/`: password files and generated TLS keypair (git-ignored)

## Prerequisites
- Docker Engine + Docker Compose v2
- `make`
- `openssl`

## Setup
1) Environment file:
```sh
cp -i srcs/.env.template srcs/.env
${EDITOR:-nano} srcs/.env
```

2) Secrets (passwords): create the files below (one value per file):
   - `secrets/db_root_password.txt`
   - `secrets/db_password.txt`
   - `secrets/wp_admin_password.txt`
   - `secrets/wp_user_password.txt`

3) Local DNS (optional):
   - Add `127.0.0.1 <DOMAIN_NAME>` to `/etc/hosts`.

## Common Commands
```sh
make        # build + up (detached)
make logs   # follow logs
make ps     # list & status of running containers
make down   # stop & remove containers (keeps data)
make fclean # removes containers & images + deletes persistent data
make re     # full rebuild (deletes persistent data)
```

## Container Management

The services are called:
- `mariadb`
- `wordpress`
- `nginx`
- `adminer` (bonus)
- `cadvisor` (bonus)

### Container Commands

```sh
# View resource usage
docker compose -f srcs/docker-compose.yml stats [service]

# View container processes
docker compose -f srcs/docker-compose.yml top [service]

# Access container shell
docker compose -f srcs/docker-compose.yml exec <service> sh
```

## Volume Management

### Volume Locations

Docker volumes for this project are stored in:
- MariaDB data: `$HOME/data/mariadb` (mounted to `/var/lib/mysql`)
- WordPress files: `$HOME/data/wordpress` (mounted to `/var/www/html`)

### Volume Commands

```sh
# List volumes
docker compose -f srcs/docker-compose.yml volumes

# View volume contents
docker run --rm -v <volume_name>:/data alpine ls -la /data
```

### Data Persistence
- `make down` keeps data.
- `make fclean` removes the volumes and deletes `$HOME/data/*`.
