# nginx-php7.4-fpm
 Nginx latest, php7.4-fpm, ubuntu 20.04
 ## Usage
Start the Docker container:

    docker run -p 80:80 denizdursun/nginx-php7.4-fpm

See the PHP info on http://localhost, or the static html page on http://localhost/test.html

Or mount your own code to be served by PHP-FPM & Nginx

    docker run -p 80:80 -v ~/my-codebase:/var/www/html denizdursun/nginx-php7.4-fpm
