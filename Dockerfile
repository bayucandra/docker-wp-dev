FROM php:7.4.2-fpm-alpine3.11

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" && \
	apk update && \
	apk add --no-cache mysql-client git openssl-dev openssh-client make nginx sudo mariadb-dev icu-dev bash postgresql-dev \
	autoconf freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
	imap-dev krb5-dev krb5 libzip-dev oniguruma-dev curl-dev composer && \
	docker-php-ext-configure gd --with-freetype --with-jpeg && \
	docker-php-ext-install -j$(nproc) gd && \
	docker-php-ext-install mysqli pdo pdo_mysql imap zip mbstring curl \
	intl

COPY assets/sudoers /etc/sudoers
COPY assets/nginx-default.conf /etc/nginx/conf.d/default.conf
COPY assets/nginx.conf /etc/nginx/nginx.conf
COPY assets/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN chmod 0400 /etc/sudoers && \
    addgroup sudo -g 7777 && \
    adduser -h /home/biqdev -s /bin/sh -G users -D biqdev && \
	addgroup biqdev && \
    adduser biqdev biqdev && \
    adduser biqdev sudo && \
    adduser biqdev www-data && \
    adduser biqdev nginx

RUN mkdir /run/nginx/ && \
	chown biqdev:biqdev /run/nginx && \
	chown biqdev:biqdev /var/lib/nginx/tmp

LABEL com.biqdev.author="bayucandra@gmail.com"
LABEL com.biqdev.repo="https://github.com/bayucandra/docker-wp-dev"