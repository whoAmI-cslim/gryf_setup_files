# setup_chrony.sh
# NTP setup script for local NTP fallback in disconnected environment.
# Maintainer: Clyde Hunter
# Company: Red River
# Email: clyde.hunter@redriver.com
# Tested On: 09 April 2025 in lab environment

#!/bin/bash

LOGFILE="/var/log/setup_chrony.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Starting Chrony setup..." | tee -a "$LOGFILE"

# Function to log and check command success
run_cmd() {
    DESC="$1"
    shift
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] $DESC" | tee -a "$LOGFILE"
    "$@" >> "$LOGFILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "[$(date "+%Y-%m-%d %H:%M:%S")] ERROR during: $DESC" | tee -a "$LOGFILE"
        exit 1
    fi
}

run_cmd "Updating package list" sudo apt update
run_cmd "Installing chrony" sudo apt install -y chrony

# Backup existing config
if [ -f /etc/chrony/chrony.conf ]; then
    BACKUP="/etc/chrony/chrony.conf.backup.$(date +%s)"
    run_cmd "Backing up existing chrony.conf to $BACKUP" sudo cp /etc/chrony/chrony.conf "$BACKUP"
fi

# Copy new config
run_cmd "Copying new chrony.conf" sudo cp "$(dirname "$0")/chrony.conf" /etc/chrony/chrony.conf

run_cmd "Restarting chrony service" sudo systemctl restart chrony
run_cmd "Enabling chrony service" sudo systemctl enable chrony

run_cmd "Checking chronyc sources" chronyc sources
run_cmd "Checking chronyc tracking" chronyc tracking

echo "[$(date "+%Y-%m-%d %H:%M:%S")] Chrony setup completed successfully." | tee -a "$LOGFILE"
