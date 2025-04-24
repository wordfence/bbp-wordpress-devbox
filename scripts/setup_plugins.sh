#!/usr/bin/env bash
source "$(dirname "$0")/utils.sh"

log "Installing default plugins and themes..."

WP_CLI="wp --path=$PWD/devbox.d/web"
$WP_CLI plugin install wp-mail-catcher --activate
$WP_CLI theme install twentytwentythree --activate
$WP_CLI rewrite structure '/%postname%/' --hard
$WP_CLI rewrite flush --hard

log "Patching wp-config.php for DISALLOW_UNFILTERED_HTML..."

CONFIG="$PWD/devbox.d/web/wp-config.php"
INSERT_LINE="define( 'DISALLOW_UNFILTERED_HTML', true );"

if ! grep -q 'DISALLOW_UNFILTERED_HTML' "$CONFIG"; then
  log "Adding DISALLOW_UNFILTERED_HTML to wp-config.php..."
  sed "/^\/\* Add any custom values between this line and the \\\"stop editing\\\" line. \*\//a\
$INSERT_LINE" "$CONFIG" > "$CONFIG.tmp" && mv "$CONFIG.tmp" "$CONFIG"
fi

log "Copying Adminer..."
ADMINER_SRC="$PWD/.devbox/nix/profile/default/adminer.php"
ADMINER_DEST="$PWD/devbox.d/web/adminer.php"

if [ -f "$ADMINER_SRC" ]; then
  cp "$ADMINER_SRC" "$ADMINER_DEST"
else
  log "Warning: Adminer not found at $ADMINER_SRC"
fi
