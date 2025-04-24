#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/utils.sh"

log "Starting Devbox WordPress setup..."

bash scripts/setup_db.sh
bash scripts/setup_wordpress.sh
bash scripts/configure_php.sh
bash scripts/setup_plugins.sh

log "✅ Devbox WordPress environment setup complete!"
