# php-cli-workspace

PHP CLI Docker image for Symfony development. Published for **PHP 8.3, 8.4 and 8.5**, on **`linux/arm64` and `linux/amd64`** (Docker pulls only the platform matching your machine).

## Usage

```bash
# Latest stable (PHP 8.5)
docker pull ghcr.io/brei0x/php-cli-workspace:latest

# Pin a specific PHP version
docker pull ghcr.io/brei0x/php-cli-workspace:8.3

# Interactive shell
docker run --rm -it ghcr.io/brei0x/php-cli-workspace

# Mount a project
docker run --rm -it -v $(pwd):/app ghcr.io/brei0x/php-cli-workspace php bin/console list
```

## What's included

- PHP 8.3, 8.4 or 8.5 (Debian Trixie)
- Composer 2
- Xdebug 3 (mode `off` by default)
- Extensions: `bcmath` `bz2` `curl` `exif` `fileinfo` `gd` `intl` `mbstring` `opcache` `openssl` `pcntl` `pdo_mysql` `pdo_pgsql` `pgsql` `sodium` `sockets` `xsl` `zip`

## Debugging (Xdebug)

Xdebug is installed but disabled by default to avoid overhead. Enable it at runtime via the `XDEBUG_MODE` environment variable:

```bash
# Step debugging (PHPStorm / any DAP client)
docker run --rm -it -e XDEBUG_MODE=debug -v $(pwd):/app ghcr.io/brei0x/php-cli-workspace php bin/console …

# Profiling
docker run --rm -it -e XDEBUG_MODE=profile -v $(pwd):/app ghcr.io/brei0x/php-cli-workspace php …
```

Default settings: `client_host=host.docker.internal`, `client_port=9003`, `idekey=PHPSTORM`.

### JetBrains integration (PHPStorm / IntelliJ IDEA + PHP plugin)

The setup is identical in both IDEs — they share the same PHP plugin platform.

1. **Settings → PHP → CLI Interpreter → +** → choose **Docker**, select `ghcr.io/brei0x/php-cli-workspace`.
2. Set the path mapping: `/app` → your local project root.
3. In your run/debug configuration, add `XDEBUG_MODE=debug` as an environment variable.
4. Start the debugger listener (port 9003 is the default — no change needed).

## Updating the image

If you already have the image pulled, re-pull to get the latest version — Docker only downloads changed layers:

```bash
docker pull ghcr.io/brei0x/php-cli-workspace:latest
```

To verify the image date after pulling:

```bash
docker inspect ghcr.io/brei0x/php-cli-workspace:latest --format '{{.Created}}'
```

## Tags

| Tag      | PHP |
|----------|-----|
| `latest` | 8.5 |
| `8.5`    | 8.5 |
| `8.4`    | 8.4 |
| `8.3`    | 8.3 |

Each tag covers `linux/arm64` and `linux/amd64`. To pull the other platform (for example an amd64 image on Apple Silicon, run under emulation):

```bash
docker pull --platform linux/amd64 ghcr.io/brei0x/php-cli-workspace:latest
```

The Dockerfile itself is versioned by git tags (`vX.Y.Z`) and [GitHub releases](https://github.com/brei0x/php-cli-workspace/releases), cut from the Conventional Commits of each push to `main`. Image tags stay by PHP version, and every tag is rebuilt each Monday to pick up PHP and Debian security patches.

## Build locally

```bash
# Default (PHP 8.5)
docker build -t php-cli-workspace .

# A specific version
docker build --build-arg PHP_VERSION=8.3 -t php-cli-workspace:8.3 .
```

## License

[MIT](LICENSE). The image also ships PHP, Debian packages and Composer under their own licenses.
