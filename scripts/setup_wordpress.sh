#!/usr/bin/env bash
source "$(dirname "$0")/utils.sh"

log "Setting up WordPress core files..."

WEB_ROOT="$PWD/devbox.d/web"
WP_CLI="wp --path=$WEB_ROOT"

mkdir -p "$WEB_ROOT"
[ -f "$WEB_ROOT/index.html" ] && rm "$WEB_ROOT/index.html"

if [ ! -d "$WEB_ROOT/wp-admin" ]; then
  cp -R .devbox/nix/profile/default/share/wordpress/* "$WEB_ROOT/"
fi

chmod -R 755 "$WEB_ROOT/wp-content/"

if [ ! -f "$WEB_ROOT/wp-config.php" ]; then
  $WP_CLI config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASSWORD}" --dbhost="${DB_HOST}"
fi

if ! $WP_CLI core is-installed; then
  $WP_CLI core install --url="${WP_URL}" --title="${WP_TITLE}" --admin_user="${WP_ADMIN_USER}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_ADMIN_EMAIL}"
fi
