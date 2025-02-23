FROM phpswoole/swoole:php8.2-alpine

ARG INSTALLER_BASE_URL="https://github.com/mlocati/docker-php-extension-installer/releases"
ARG SCHEDULE_CRONTAB="* * * * * cd /var/www && php artisan schedule:run >> /dev/null 2>&1"

ADD $INSTALLER_BASE_URL/latest/download/install-php-extensions /usr/local/bin/

ENV TZ=UTC

### default laravel octane dependencies
RUN crontab -l | { cat; echo "$SCHEDULE_CRONTAB"; } | crontab - \
    && chmod +x /usr/local/bin/install-php-extensions \
    && apk update && apk upgrade && apk add --update \
    postgresql-client \
    mariadb-client \
    supervisor \
    xdg-utils \
    pngcrush \
    tzdata \
    nodejs \
    npm \
    zip \
    ffmpeg

### install some default fonts
RUN apk add --update \
    font-terminus \
    font-inconsolata \
    font-dejavu \
    font-noto \
    font-noto-cjk \
    font-awesome \
    font-noto-extra

### build essentials for node canvas
RUN apk add --update --no-cache \
    make \
    g++ \
    jpeg-dev \
    cairo-dev \
    giflib-dev \
    pango-dev \
    libtool \
    autoconf \
    automake

### required php dependencies
RUN install-php-extensions \
    @composer \
    apcu \
    bcmath \
    gd \
    imagick \
    intl \
    memcached \
    opcache \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    redis \
    zip

### set timezone and clean-up
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apk del tzdata \
    && rm -rf /usr/local/bin/install-php-extensions \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/cache/apk/*

# 将 /run 目录的所有权更改为 nobody 用户，确保非 root 用户可以访问。
RUN #chown -R nobody.nobody /run

# 创建应用目录
#RUN mkdir -p /var/www

# Make the document root a volume
VOLUME /var/www

# Switch to use a non-root user from here on
#USER root

# Add application
WORKDIR /var/www

### default php ini files
COPY config/octane.ini /usr/local/etc/php/conf.d/octane.ini

# 暴露端口 workman端口
EXPOSE 8000 6001

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]