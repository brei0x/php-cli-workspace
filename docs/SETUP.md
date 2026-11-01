# Setup

Using, debugging, building and releasing the `ghcr.io/brei0x/php-cli-workspace` image.

## Use the image

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

### Update a pulled image

Re-pull to get the latest build (Docker only downloads changed layers), then check its date:

```bash
docker pull ghcr.io/brei0x/php-cli-workspace:latest
docker inspect ghcr.io/brei0x/php-cli-workspace:latest --format '{{.Created}}'
```

### Pull the other platform

Each tag covers `linux/arm64` and `linux/amd64`. To pull the other platform (for example an amd64 image on Apple Silicon, run under emulation):

```bash
docker pull --platform linux/amd64 ghcr.io/brei0x/php-cli-workspace:latest
```

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

   Run them from Tools → Run Command… (`Ctrl+Shift+X`): `s about`, `c -d /opt/project install`, `c -d /opt/project require symfony/mailer --dev`. `Process finished with exit code 0` means success.
   The IDE runs a tool from its script's directory, so `c` starts in `/usr/local/bin`: `-d /opt/project` points Composer at the project, or use step 2 instead.
4. **Debugging**: in a run/debug configuration, set `XDEBUG_MODE=debug` and start listening on port 9003 (default).

Notes:

- Use a real Xdebug mode (`debug`, `profile`…), never `on`: PHP reads it as `1`, which Xdebug rejects.
- `bin/console about` shows `Xdebug true` as soon as the extension is loaded, even with mode `off`.
- Each command runs in a fresh container: add `--network <name>` to the interpreter's Docker container options to reach a database or other services.
- The IDE's built-in Terminal runs on your machine, not in the container: aliases `s` and `c` do not exist there.

## Build locally

```bash
# Default (PHP 8.5)
docker build -t php-cli-workspace .

# A specific version
docker build --build-arg PHP_VERSION=8.3 -t php-cli-workspace:8.3 .

# Smoke-test the extensions, as CI does
docker run --rm php-cli-workspace php -m
```

## Pipeline

- **Pull request**: `ci.yml` builds every PHP version on each platform's native runner and lists its extensions with `php -m`.
- **Push to `main`**: `publish.yml` builds and pushes every PHP version for both platforms, applies the image tags, prunes the untagged images of earlier runs, then tags the commit (`vX.Y.Z`, from the Conventional Commits since the last tag) and publishes the [GitHub release](https://github.com/brei0x/php-cli-workspace/releases).
- **Every Monday**: `publish.yml` rebuilds every tag on fresh base images to pick up PHP and Debian security patches, without cutting a release.

Image tags stay by PHP version; the git tags version the Dockerfile. Adding or dropping a PHP version, and the pipeline internals, are in [CLAUDE.md](../CLAUDE.md).
