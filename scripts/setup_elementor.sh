#!/usr/bin/env bash
source "$(dirname "$0")/utils.sh"

WP_CLI="wp --path=$PWD/devbox.d/web"

log "Installing Elementor..."

$WP_CLI plugin install elementor --activate
