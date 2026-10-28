# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repo is a Docker image (`ghcr.io/brei0x/php-cli-workspace`) providing a PHP CLI environment for Symfony development. It bundles Composer 2 and a standard set of PHP extensions. The same `Dockerfile` is parameterised by a `PHP_VERSION` build arg and published for **PHP 8.3, 8.4 and 8.5** from a single CI matrix.

## Build & Test

```bash
# Build locally (default PHP 8.5)
docker build -t php-cli-workspace .

# Build a specific PHP version
docker build --build-arg PHP_VERSION=8.3 -t php-cli-workspace:8.3 .

# Run interactively
docker run --rm -it php-cli-workspace

# Smoke-test extensions
docker run --rm php-cli-workspace php -m
```

## Release Pipeline

A pull request runs `.github/workflows/ci.yml`: every PHP version is built on each platform's native runner and `php -m` lists its extensions. A push to `main` runs `.github/workflows/publish.yml`: the matrix builds one image per PHP version and platform, a per-version `merge` job assembles the manifest list and applies the image tags (`max-parallel: 1`, in matrix order: the GHCR package page shows the last pushed tag as its install command, so the `LATEST_PHP` version stays last in the matrix), a `cleanup` job (`dataaxiom/ghcr-cleanup-action`) drops the untagged image trees left by earlier runs, then the shared `tekalib/.workflows` release job tags the commit from the Conventional Commits since the last `v*` tag (`feat` = minor, `fix` and the rest = patch, `!` = major) and publishes the GitHub release. No file holds the version: the last tag does. Published image tags: `8.3`, `8.4`, `8.5`, and `latest` (→ the version in the `LATEST_PHP` env var, currently `8.5`). The same workflow also runs every Monday (`schedule`) to rebuild every tag on fresh base images: the `release` job is skipped then, so no empty release is cut. No manual publish step needed.

The image is published for **`linux/arm64` and `linux/amd64`**, each built on its native runner (`ubuntu-26.04-arm`, `ubuntu-26.04`) so no QEMU emulation is involved. Every tag is a manifest list: `docker pull` fetches only the platform matching the host. The `arch` matrix axis and its `include` runner mapping live in both workflows; keep them identical.

## Architecture

- **`Dockerfile`** — single-stage build from `php:${PHP_VERSION}-cli-trixie` (`PHP_VERSION` build arg, default `8.5`). Composer is copied from the official `composer:2` image. All PHP extensions are compiled via `docker-php-ext-install` in one `RUN` layer to minimise image size.
- **`.github/workflows/ci.yml`** — pull request check: build every PHP version on each platform and `php -m`.
- **`.github/workflows/publish.yml`** — CI/CD; uses `docker/setup-buildx-action`, `docker/metadata-action`, and `docker/build-push-action` for the GHCR push by digest, with an SBOM and a full (`mode=max`) SLSA provenance attached to every platform image. Each tag is an OCI index whose platform images and `unknown/unknown` attestation manifests show up as untagged package versions: never delete those by hand or with `actions/delete-package-versions`, it breaks the pull; the `cleanup` job reference-counts them. The workflow runs under one `concurrency` group so a cleanup never removes another run's digests before its `merge`. The version list lives in the `build`/`merge` matrices, the `ci.yml` matrix and the `LATEST_PHP` env var: update all four when adding or dropping a PHP version.

## Version Policy

Always use the latest stable versions. Before any modification, verify and update if needed:

- **PHP base image** — `php:X.Y-cli-trixie` (track the latest stable PHP minor, e.g. 8.5 → 8.6 when released, and the current Debian stable release).
- **Composer** — `composer:2` (floating tag is fine; pin to `composer:2.x` if reproducibility matters).
- **GitHub Actions** — every `uses:` is pinned to a full commit SHA with the release tag in a trailing comment (`@<sha> # v6.1.0`); the repository enforces SHA pinning, so a tag reference fails the run. Dependabot (`.github/dependabot.yml`, daily, 7-day cooldown) proposes the bumps; when bumping by hand, resolve the tag to its commit SHA (dereference annotated tags) and validate with `actionlint` and `zizmor`.

## Extension List (compiled-in)

`bcmath bz2 exif fileinfo gd intl mbstring pcntl pdo_mysql pdo_pgsql pgsql sodium sockets xsl zip`

> `curl`, `openssl`, and `opcache` are built into the official `php:*-cli-*` images — do not add them to `docker-php-ext-install`.

When adding a new extension, add both the system-level `apt-get install` dependency (if any) and the `docker-php-ext-install` entry in the same `RUN` block.

## Xdebug

Installed via `pecl install xdebug` (latest stable; 3.5.3 as of 2026-10-21). Configured in `/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini`.

- `xdebug.mode=off` by default — enable at runtime with `XDEBUG_MODE=debug`.
- `client_host=host.docker.internal`, `client_port=9003`, `idekey=PHPSTORM`.
- Do **not** change `mode` in the ini file — keep it `off` so the image stays fast when not debugging.
