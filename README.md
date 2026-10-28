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

### JetBrains integration (PhpStorm / IntelliJ IDEA + PHP plugin)

Both IDEs share the same PHP plugin, so the setup is identical.

1. **Interpreter**: Settings → PHP → CLI Interpreter → **…** → **+** → From Docker, image `ghcr.io/brei0x/php-cli-workspace:latest`. Keep the default container volume (project root → `/opt/project`). Optional configuration options: `-dmemory_limit=512M`.
2. **Composer**: Settings → PHP → Composer → Execution: **Remote Interpreter**. Then use Tools → Composer → Install, or the links above `composer.json`.
3. **Commands**: Settings → Tools → PHP Command Line Tool Support → **+**, remote interpreter:

   | Tool                                   | Path                       | Alias |
   |----------------------------------------|----------------------------|-------|
   | Symfony                                | `/opt/project/bin/console` | `s`   |
   | Composer (composer.phar or php script) | `/usr/local/bin/composer`  | `c`   |

   Run them from Tools → Run Command… (`Ctrl+Shift+X`): `s about`, `c install`, `c require symfony/mailer --dev`. `Process finished with exit code 0` means success.
4. **Debugging**: in a run/debug configuration, set `XDEBUG_MODE=debug` and start listening on port 9003 (default).

Notes:

- Use a real Xdebug mode (`debug`, `profile`…), never `on`: PHP reads it as `1`, which Xdebug rejects.
- `bin/console about` shows `Xdebug true` as soon as the extension is loaded, even with mode `off`.
- Each command runs in a fresh container: add `--network <name>` to the interpreter's Docker container options to reach a database or other services.
- The IDE's built-in Terminal runs on your machine, not in the container: aliases `s` and `c` do not exist there.

## Updating the image

If you already have the image pulled, re-pull to get the latest version (Docker only downloads changed layers):

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
