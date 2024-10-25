FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    supervisor \
    nginx \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

COPY . .

RUN echo   > ./storage/logs/queue.log
RUN echo   > ./storage/logs/laravel.log
RUN echo   > ./storage/logs/serve.log

RUN composer install --no-interaction --prefer-dist --optimize-autoloader

COPY ./supervisor/conf.d /etc/supervisor/conf.d 

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

COPY supervisord.conf /etc/supervisor/supervisord.conf

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 80 8000

ENTRYPOINT ["/entrypoint.sh"]