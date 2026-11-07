#!/bin/sh
set -e

# Set permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Cache config, routes, and views
php /var/www/html/artisan config:cache
php /var/www/html/artisan route:cache
php /var/www/html/artisan view:cache

# Run database migrations
php /var/www/html/artisan migrate --force

# Start supervisord (nginx + php-fpm + queue + schedule)
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf