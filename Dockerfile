FROM php:7.4.2-fpm-alpine3.11

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" && \
	apk update && \
	apk add --no-cache mysql-client git openssl-dev openssh-client make sudo mariadb-dev icu-dev bash postgresql-dev \
	autoconf freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
	imap-dev krb5-dev krb5 libzip-dev oniguruma-dev curl-dev composer && \
	docker-php-ext-configure gd --with-freetype --with-jpeg && \
	docker-php-ext-install -j$(nproc) gd && \
	docker-php-ext-install mysqli pdo pdo_mysql imap zip mbstring curl \
	intl

COPY assets/sudoers /etc/sudoers

RUN chmod 0400 /etc/sudoers && \
    addgroup sudo
