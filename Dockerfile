FROM ubuntu:20.04
LABEL maintainer = "Deniz Dursun denizdursun@gmail.com"

# Env
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update -y
RUN apt-get install -y php \
php7.4-fpm \
php7.4-cli \
php7.4-cgi \
php7.4-pdo \
php7.4-mbstring \
php7.4-odbc \
php7.4-imap \
php7.4-gd \
php7.4-xml \
php7.4-soap \
php7.4-dev \
php7.4-curl \ 
php7.4-apc \ 
php7.4-apcu \ 
nginx \
supervisor \
curl

# Nginx
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/conf.d/default.conf /etc/nginx/conf.d/default.conf

# PHP-FPM
COPY config/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY config/php.ini /etc/php/7.4/fpm/conf.d/custom.ini

# Supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Socument root
RUN mkdir -p /var/www/html

# Files/folders needed by the processes are accessible when they run under the www-data user
RUN chown -R www-data.www-data /var/www/html && \
  chown -R www-data.www-data /run && \
  chown -R www-data.www-data /var/lib/nginx && \
  chown -R www-data.www-data /var/log/nginx

# Switch to use a non-root user from here on
RUN usermod -u 1000 www-data

# Logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Application
WORKDIR /var/www/html
COPY --chown=www-data src/ /var/www/html/

# Ports
EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping