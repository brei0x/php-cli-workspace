# PHP minor version to build (8.3, 8.4 or 8.5). Override at build time:
#   docker build --build-arg PHP_VERSION=8.3 .
ARG PHP_VERSION=8.5
FROM php:${PHP_VERSION}-cli-trixie

# Re-declare after FROM so the value is available in this build stage.
ARG PHP_VERSION

LABEL org.opencontainers.image.title="php-cli-workspace"
LABEL org.opencontainers.image.description="PHP ${PHP_VERSION} CLI for Symfony development"
LABEL org.opencontainers.image.vendor="brei0x"

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# System dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libbz2-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    libsodium-dev \
    libxml2-dev \
    libxslt1-dev \
    libonig-dev \
    libzip-dev \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        bz2 \
        exif \
        fileinfo \
        gd \
        intl \
        mbstring \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        sodium \
        sockets \
        xsl \
        zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Xdebug (mode=off by default; override with XDEBUG_MODE=debug at runtime)
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && { \
        echo '[xdebug]'; \
        echo 'xdebug.mode=off'; \
        echo 'xdebug.start_with_request=yes'; \
        echo 'xdebug.client_host=host.docker.internal'; \
        echo 'xdebug.client_port=9003'; \
        echo 'xdebug.idekey=PHPSTORM'; \
        echo 'xdebug.log_level=0'; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && rm -rf /tmp/pear

WORKDIR /app

CMD ["php", "-a"]
