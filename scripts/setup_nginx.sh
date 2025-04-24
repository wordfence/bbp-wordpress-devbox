#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/utils.sh"

log "Building nginx.conf from template..."

export PROJECT_ROOT="$PWD"
export WEB_ROOT="$PWD/devbox.d/web"
export NGINX_PORT="${NGINX_PORT:-8081}"
export PHP_FPM_PORT="${PHP_FPM_PORT:-8082}"

envsubst '${NGINX_PORT} ${WEB_ROOT} ${PHPFPM_PORT} ${PROJECT_ROOT}' \
  < nginx/nginx.template > devbox.d/nginx/nginx.template

log "✅ nginx.conf generated"