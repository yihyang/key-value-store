# Base image is built from Dockerfile.base and push to ECR
FROM 123456789012.dkr.ecr.ap-southeast-1.amazonaws.com/carro/php-base:latest

# Set working directory
WORKDIR /var/www/carro

COPY ./composer.json /var/www/carro
COPY ./composer.lock /var/www/carro

RUN composer install --no-scripts --no-autoloader --no-ansi --no-interaction --working-dir=/var/www/carro

ENV USER=www-data

RUN mkdir -p /home/$USER/.composer && \
    chown -R $USER:$USER /home/$USER

# Copy application code into container
ADD . /var/www/carro

RUN chown -R $USER /var/www

RUN composer dump-autoload --optimize --no-ansi --no-interaction --working-dir=/var/www/carro \
 --no-ansi --no-interaction --working-dir=/var/www/carro

# Copy supervisor scripts into container (only used by worker servers)
COPY supervisord.conf /etc/supervisor

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
