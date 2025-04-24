#!/usr/bin/env bash
source "$(dirname "$0")/utils.sh"

WP_CLI="wp --path=$PWD/devbox.d/web"

log "Creating demo users..."

$WP_CLI user create user_subscriber user_subscriber@example.com --role=subscriber --user_pass=password
$WP_CLI user create user_contributor user_contributor@example.com --role=contributor --user_pass=password
$WP_CLI user create user_author user_author@example.com --role=author --user_pass=password
$WP_CLI user create user_editor user_editor@example.com --role=editor --user_pass=password
