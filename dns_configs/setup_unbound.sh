# setup_unbound.sh
# Unbound setup script
# Maintainer: Clyde Hunter
# Company: Red River
# Email: clyde.hunter@redriver.com
# Tested On: 09 April 2025 in lab environment

#!/bin/bash
set -euo pipefail

# Logging functions
log_info() {
  echo -e "[\$(date '+%Y-%m-%d %H:%M:%S')] [INFO] \$*"
}

log_warn() {
  echo -e "[\$(date '+%Y-%m-%d %H:%M:%S')] [WARN] \$*" >&2
}

log_error() {
  echo -e "[\$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] \$*" >&2
}

# Run command with logging and error handling
run_cmd() {
  log_info "Running: \$*"
  if ! "\$@"; then
    log_error "Command failed: \$*"
    exit 1
  fi
}

log_info "Starting Unbound setup..."

# Install unbound
run_cmd sudo apt update
run_cmd sudo apt install -y unbound

# Copy unbound.conf
run_cmd sudo cp ./unbound.conf /etc/unbound/unbound.conf

# Download root hints
run_cmd sudo wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache

# Set ownership of root hints
run_cmd sudo chown unbound:unbound /var/lib/unbound/root.hints

# Check unbound configuration
run_cmd sudo unbound-checkconf

# Setup unbound-control keys
run_cmd sudo unbound-control-setup

# Reload unbound with new config
run_cmd sudo unbound-control reload

# Enable unbound service at boot
run_cmd sudo systemctl enable unbound

# Restart unbound service
run_cmd sudo systemctl restart unbound

# Show unbound service status
run_cmd sudo systemctl status unbound

log_info "Unbound setup completed successfully."
