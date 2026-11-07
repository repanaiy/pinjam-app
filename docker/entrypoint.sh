#!/bin/sh
set -e

# Run database migrations FIRST (config:cache/route:cache below need
# the DB ready because CACHE_STORE defaults to 'database')
php /var/www/html/artisan migrate --force

# Set permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Cache config, routes, and views AFTER migration
php /var/www/html/artisan config:cache
php /var/www/html/artisan route:cache
php /var/www/html/artisan view:cache

# Start supervisord (nginx + php-fpm + queue + schedule)
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf