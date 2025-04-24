#!/usr/bin/env bash
source "$(dirname "$0")/utils.sh"

log "Ensuring .htaccess exists and contains WordPress rewrite rules..."

WEB_ROOT="$PWD/devbox.d/web"
HTACCESS="$WEB_ROOT/.htaccess"

# Create .htaccess if missing
if [ ! -f "$HTACCESS" ]; then
  echo 'DirectoryIndex index.php index.html' > "$HTACCESS"
fi

# Append WordPress rules if not already present
if ! grep -q 'BEGIN WordPress' "$HTACCESS"; then
  cat >> "$HTACCESS" <<EOF
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOF
fi

# Patch Apache config to enable mod_rewrite
APACHE_CONF="$PWD/devbox.d/apache/httpd.conf"
if [ -f "$APACHE_CONF" ] && ! grep -q '^LoadModule rewrite_module modules/mod_rewrite.so' "$APACHE_CONF"; then
  log "Patching Apache config to enable mod_rewrite..."
  sed '/LoadModule log_config_module modules\/mod_log_config.so/a\
LoadModule rewrite_module modules/mod_rewrite.so' "$APACHE_CONF" > "$APACHE_CONF.tmp" && mv "$APACHE_CONF.tmp" "$APACHE_CONF"
fi
