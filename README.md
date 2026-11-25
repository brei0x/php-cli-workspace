<p align="center">
  <img src="docs/assets/banner.webp" alt="php-cli-workspace banner: a terminal running the image, showing PHP 8.5.13 with Xdebug 3.5.3 and Composer 2.11.3" width="100%">
</p>

# php-cli-workspace

PHP CLI Docker image for Symfony development, published for **PHP 8.3, 8.4 and 8.5** on **`linux/arm64` and `linux/amd64`** (Docker pulls only the platform matching your machine).

<p align="center">
  <a href="https://github.com/brei0x/php-cli-workspace/actions/workflows/publish.yml"><img src="https://github.com/brei0x/php-cli-workspace/actions/workflows/publish.yml/badge.svg?branch=main" alt="Publish"></a>
  <a href="https://github.com/brei0x/php-cli-workspace/releases/latest"><img src="https://img.shields.io/github/v/release/brei0x/php-cli-workspace?sort=semver&label=release&labelColor=24292e&logo=data:image/svg%2Bxml;base64,PHN2ZyBmaWxsPSIjOTU5ZGE1IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgdmlld0JveD0iMCAwIDE2IDE2Ij48cGF0aCBkPSJNMSA3Ljc3NVYyLjc1QzEgMS43ODQgMS43ODQgMSAyLjc1IDFoNS4wMjVjLjQ2NCAwIC45MS4xODQgMS4yMzguNTEzbDYuMjUgNi4yNWExLjc1IDEuNzUgMCAwIDEgMCAyLjQ3NGwtNS4wMjYgNS4wMjZhMS43NSAxLjc1IDAgMCAxLTIuNDc0IDBsLTYuMjUtNi4yNUExLjc1MiAxLjc1MiAwIDAgMSAxIDcuNzc1Wm0xLjUgMGMwIC4wNjYuMDI2LjEzLjA3My4xNzdsNi4yNSA2LjI1YS4yNS4yNSAwIDAgMCAuMzU0IDBsNS4wMjUtNS4wMjVhLjI1LjI1IDAgMCAwIDAtLjM1NGwtNi4yNS02LjI1YS4yNS4yNSAwIDAgMC0uMTc3LS4wNzNIMi43NWEuMjUuMjUgMCAwIDAtLjI1LjI1Wk02IDVhMSAxIDAgMSAxIDAgMiAxIDEgMCAwIDEgMC0yWiIvPjwvc3ZnPg%3D%3D" alt="Latest release"></a>
  <a href="https://github.com/brei0x/php-cli-workspace/blob/main/LICENSE"><img src="https://img.shields.io/github/license/brei0x/php-cli-workspace?labelColor=24292e&logo=data:image/svg%2Bxml;base64,PHN2ZyBmaWxsPSIjOTU5ZGE1IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgdmlld0JveD0iMCAwIDE2IDE2Ij48cGF0aCBkPSJNOC43NS43NVYyaC45ODVjLjMwNCAwIC42MDMuMDguODY3LjIzMWwxLjI5LjczNmMuMDM4LjAyMi4wOC4wMzMuMTI0LjAzM2gyLjIzNGEuNzUuNzUgMCAwIDEgMCAxLjVoLS40MjdsMi4xMTEgNC42OTJhLjc1Ljc1IDAgMCAxLS4xNTQuODM4bC0uNTMtLjUzLjUyOS41MzEtLjAwMS4wMDItLjAwMi4wMDItLjAwNi4wMDYtLjAwNi4wMDUtLjAxLjAxLS4wNDUuMDRjLS4yMS4xNzYtLjQ0MS4zMjctLjY4Ni40NUMxNC41NTYgMTAuNzggMTMuODggMTEgMTMgMTFhNC40OTggNC40OTggMCAwIDEtMi4wMjMtLjQ1NCAzLjU0NCAzLjU0NCAwIDAgMS0uNjg2LS40NWwtLjA0NS0uMDQtLjAxNi0uMDE1LS4wMDYtLjAwNi0uMDA0LS4wMDR2LS4wMDFhLjc1Ljc1IDAgMCAxLS4xNTQtLjgzOEwxMi4xNzggNC41aC0uMTYyYy0uMzA1IDAtLjYwNC0uMDc5LS44NjgtLjIzMWwtMS4yOS0uNzM2YS4yNDUuMjQ1IDAgMCAwLS4xMjQtLjAzM0g4Ljc1VjEzaDIuNWEuNzUuNzUgMCAwIDEgMCAxLjVoLTYuNWEuNzUuNzUgMCAwIDEgMC0xLjVoMi41VjMuNWgtLjk4NGEuMjQ1LjI0NSAwIDAgMC0uMTI0LjAzM2wtMS4yODkuNzM3Yy0uMjY1LjE1LS41NjQuMjMtLjg2OS4yM2gtLjE2MmwyLjExMiA0LjY5MmEuNzUuNzUgMCAwIDEtLjE1NC44MzhsLS41My0uNTMuNTI5LjUzMS0uMDAxLjAwMi0uMDAyLjAwMi0uMDA2LjAwNi0uMDE2LjAxNS0uMDQ1LjA0Yy0uMjEuMTc2LS40NDEuMzI3LS42ODYuNDVDNC41NTYgMTAuNzggMy44OCAxMSAzIDExYTQuNDk4IDQuNDk4IDAgMCAxLTIuMDIzLS40NTQgMy41NDQgMy41NDQgMCAwIDEtLjY4Ni0uNDVsLS4wNDUtLjA0LS4wMTYtLjAxNS0uMDA2LS4wMDYtLjAwNC0uMDA0di0uMDAxYS43NS43NSAwIDAgMS0uMTU0LS44MzhMMi4xNzggNC41SDEuNzVhLjc1Ljc1IDAgMCAxIDAtMS41aDIuMjM0YS4yNDkuMjQ5IDAgMCAwIC4xMjUtLjAzM2wxLjI4OC0uNzM3Yy4yNjUtLjE1LjU2NC0uMjMuODY5LS4yM2guOTg0Vi43NWEuNzUuNzUgMCAwIDEgMS41IDBabTIuOTQ1IDguNDc3Yy4yODUuMTM1LjcxOC4yNzMgMS4zMDUuMjczczEuMDItLjEzOCAxLjMwNS0uMjczTDEzIDYuMzI3Wm0tMTAgMGMuMjg1LjEzNS43MTguMjczIDEuMzA1LjI3M3MxLjAyLS4xMzggMS4zMDUtLjI3M0wzIDYuMzI3WiIvPjwvc3ZnPg%3D%3D" alt="License"></a>
</p>

---

**Stack**: Docker · PHP on Debian Trixie (`php:*-cli-trixie`) · Composer 2 · Xdebug 3 · GitHub Container Registry · GitHub Actions

## Documentation

| Doc | Content |
| --- | --- |
| [docs/SETUP.md](docs/SETUP.md) | Usage, updating, other platform, Xdebug and JetBrains setup, local build, pipeline |
| [Releases](https://github.com/brei0x/php-cli-workspace/releases) | Dockerfile versions (`vX.Y.Z`) and their changes |
| [Security policy](https://github.com/brei0x/php-cli-workspace/security/policy) | How to report a vulnerability; served by `brei0x/.github` |
| [CLAUDE.md](CLAUDE.md) | Project context for Claude Code: pipeline internals, version policy, extensions |

## Quick start

Requires **Docker** (or any OCI runtime).

```bash
docker pull ghcr.io/brei0x/php-cli-workspace:latest
docker run --rm -it -v $(pwd):/app ghcr.io/brei0x/php-cli-workspace php bin/console list
```

Xdebug is off by default: run with `-e XDEBUG_MODE=debug` to step-debug. IDE setup and the other recipes are in **[docs/SETUP.md](docs/SETUP.md)**.

## What's included

- PHP 8.3, 8.4 or 8.5 (Debian Trixie)
- Composer 2
- Xdebug 3 (mode `off` by default; `client_host=host.docker.internal`, `client_port=9003`, `idekey=PHPSTORM`)
- Extensions: `bcmath` `bz2` `curl` `exif` `fileinfo` `gd` `intl` `mbstring` `opcache` `openssl` `pcntl` `pdo_mysql` `pdo_pgsql` `pgsql` `sodium` `sockets` `xsl` `zip`

## Commands

```bash
docker build -t php-cli-workspace .                                       # Build the default version (PHP 8.5)
docker build --build-arg PHP_VERSION=8.3 -t php-cli-workspace:8.3 .       # Build a specific version
docker run --rm php-cli-workspace php -m                                  # List the extensions, as CI does
```

## Environments

| Branch | Registry                                | Tags                                      |
| ------ | --------------------------------------- | ----------------------------------------- |
| `main` | `ghcr.io/brei0x/php-cli-workspace`      | `latest` (8.5), `8.5`, `8.4`, `8.3`       |

Publishing is **automatic** on every push to `main`, which also tags the commit and publishes its GitHub release. Every tag is rebuilt each Monday to pick up PHP and Debian security patches. Pipeline details: [docs/SETUP.md](docs/SETUP.md#pipeline).

## Workflow

One branch per task (`feat/…`, `fix/…`, `chore/…`), Conventional Commits, PRs target `main`. Before pushing:

```bash
docker build -t php-cli-workspace . && docker run --rm php-cli-workspace php -m
```
