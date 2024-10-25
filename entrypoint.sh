#!/bin/sh

# Create the Supervisor socket directory
mkdir -p /var/run/supervisor

# Start Nginx
service nginx start

# Start PHP-FPM
php-fpm &

# Start Supervisor
supervisord -c /etc/supervisor/supervisord.conf -n