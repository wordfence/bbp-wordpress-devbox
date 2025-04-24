#!/usr/bin/env bash
source "$(dirname "$0")/utils.sh"

WP_CLI="wp --path=$PWD/devbox.d/web"

log "Installing and configuring WooCommerce..."

$WP_CLI plugin install woocommerce --activate
$WP_CLI theme install storefront --activate
$WP_CLI plugin install wordpress-importer --activate

log "Importing WooCommerce sample data..."
$WP_CLI import $PWD/devbox.d/web/wp-content/plugins/woocommerce/sample-data/sample_products.xml --authors=skip --quiet

log "✅ WooCommerce demo setup complete."