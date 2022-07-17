ARG IMAGE_NAME
ARG BASE_TAG

FROM ${IMAGE_NAME}:${BASE_TAG}

ARG PORT

WORKDIR /var/www

COPY --chown=www-data:www-data . ./

ADD --chown=www-data:www-data ./dockers/start.sh /

ADD --chown=www-data:www-data ./nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

ADD --chown=www-data:www-data ./supervisor/conf.d/laravel-worker.conf /etc/supervisor/conf.d/laravel-worker.conf

# ADD --chown=www-data:www-data ./php-fpm/www.conf /etc/php/8.0/fpm/pool.d/www.conf

RUN chmod +x /start.sh

RUN chmod -R 777 storage bootstrap/cache

RUN composer self-update --2
RUN composer install

EXPOSE ${PORT}

# ENTRYPOINT [ "/start.sh" ]
CMD [ "/start.sh" ]
