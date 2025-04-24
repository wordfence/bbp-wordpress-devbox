#!/usr/bin/env bash
source "$(dirname "$0")/utils.sh"

log "Configuring PHP..."

PHP_INI="$PWD/devbox.d/php/php.ini"
mkdir -p "$(dirname "$PHP_INI")"
touch "$PHP_INI"

append_if_missing() {
  local key="$1"
  local value="$2"
  grep -q "^$key" "$PHP_INI" || echo "$key=$value" >> "$PHP_INI"
}

append_if_missing "zend_extension" "$PWD/.devbox/nix/profile/default/lib/php/extensions/xdebug.so"
append_if_missing "xdebug.mode" "debug"
append_if_missing "xdebug.start_with_request" "yes"
append_if_missing "xdebug.client_port" "9003"
append_if_missing "xdebug.client_host" "127.0.0.1"
append_if_missing "xdebug.log" "/tmp/xdebug.log"
append_if_missing "upload_max_filesize" "64M"
append_if_missing "post_max_size" "64M"
append_if_missing "memory_limit" "512M"
append_if_missing "max_execution_time" "120"
