# User Documentation

## Services
This infrastructure provides the following services:

- **WordPress Website**: A fully functional WordPress CMS accessible via HTTPS.
- **Web Server**: Nginx serving content with TLS 1.2/1.3 encryption.
- **Database**: MariaDB storing WordPress content and user data.

All services run in isolated Docker containers and communicate through a private network.
Only port `443` is exposed to the host (for HTTPS traffic).

## Start and Stop
```sh
make        # build + start (detached)
make logs   # follow logs
make stop   # stop containers (keeps data)
make fclean # removes containers & images + deletes persistent data
```

## Access
- Website: `https://<DOMAIN_NAME>`
- Admin: `https://<DOMAIN_NAME>/wp-admin/`

If the service is running locally, replace `<DOMAIN_NAME>` with `127.0.0.1`.

In that case, your browser will show a security warning because a self-signed certificate is used to enable HTTPS.
This is expected and not concerning for a service running locally. Proceed anyway.

## Credentials

- Non-secret configuration lives in `srcs/.env`.
- Initial passwords are Docker secrets stored as files under `secrets/`:
  | Used for | File |
  |---|---|
  | MariaDB root password | `secrets/db_root_password.txt` |
  | WordPress DB user password | `secrets/db_password.txt` |
  | WordPress admin password | `secrets/wp_admin_password.txt` |
  | WordPress user password | `secrets/wp_user_password.txt` |

## Service Status
```sh
make ps
```

## Bonus Services

Bonus services are disabled by default. To enable them, prefix any command with `BONUS=1`:
```sh
BONUS=1 make        # build + start with bonus services
BONUS=1 make logs   # follow logs including bonus services
```

### Adminer
A database management interface for MariaDB.

**Access:** `http://localhost:8080`

**Login:**
- System: `MySQL`
- Server: `mariadb`
- Username: Value of `MYSQL_USER` from `srcs/.env`
- Password: Content of `secrets/db_password.txt`
- Database: Value of `MYSQL_DATABASE` from `srcs/.env`

### cAdvisor
Monitors resource usage of running containers.

**Access:** `http://localhost:8082`
