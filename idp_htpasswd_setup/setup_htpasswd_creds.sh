# setup_htpasswd_creds.sh
# Identity Platform setup script for basic email/password based on an htpasswd file.
# Maintainer: Clyde Hunter
# Company: Red River
# Email: clyde.hunter@redriver.com
# Tested On: 09 April 2025 in lab environment

#!/bin/bash

LOGFILE="/var/log/setup_htpasswd.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Starting IDP htpasswd setup..." | tee -a "$LOGFILE"

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

# Load environment variables
if [ -f "$(dirname "$0")/../.env" ]; then
    set -o allexport
    source "$(dirname "$0")/../.env"
    set +o allexport
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] Loaded environment variables from .env" | tee -a "$LOGFILE"
else
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] .env file not found, exiting." | tee -a "$LOGFILE"
    exit 1
fi

run_cmd "Installing apache2-utils" sudo apt-get install -y apache2-utils

HTPASSWD_FILE="$(dirname "$0")/users.htpasswd"

# Show existing users if file exists
if [ -f "$HTPASSWD_FILE" ]; then
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] Existing users in htpasswd file:" | tee -a "$LOGFILE"
    cut -d: -f1 "$HTPASSWD_FILE" | tee -a "$LOGFILE"
else
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] No existing htpasswd file found." | tee -a "$LOGFILE"
fi

# User management
echo "Do you want to (a)dd a user, (r)emove a user, or (u)se defaults from .env? [a/r/u]"
read -r ACTION

case "$ACTION" in
    a|A)
        echo "Enter username:"
        read -r NEWUSER
        echo "Enter password:"
        read -rs NEWPASS
        echo
        if [ ! -f "$HTPASSWD_FILE" ]; then
            run_cmd "Creating new htpasswd file with user $NEWUSER" htpasswd -c -B -b "$HTPASSWD_FILE" "$NEWUSER" "$NEWPASS"
        else
            run_cmd "Adding user $NEWUSER to htpasswd file" htpasswd -B -b "$HTPASSWD_FILE" "$NEWUSER" "$NEWPASS"
        fi
        ;;
    r|R)
        echo "Enter username to remove:"
        read -r DELUSER
        if [ -f "$HTPASSWD_FILE" ]; then
            run_cmd "Removing user $DELUSER from htpasswd file" htpasswd -D "$HTPASSWD_FILE" "$DELUSER"
        else
            echo "[$(date "+%Y-%m-%d %H:%M:%S")] htpasswd file does not exist." | tee -a "$LOGFILE"
            exit 1
        fi
        ;;
    u|U)
        if [ ! -f "$HTPASSWD_FILE" ]; then
            run_cmd "Creating new htpasswd file with default user $CHIIPS_DEFAULT_ADMIN" htpasswd -c -B -b "$HTPASSWD_FILE" "$CHIIPS_DEFAULT_ADMIN" "$CHIIPS_DEFAULT_ADMIN_PW"
        else
            run_cmd "Adding default user $CHIIPS_DEFAULT_ADMIN to htpasswd file" htpasswd -B -b "$HTPASSWD_FILE" "$CHIIPS_DEFAULT_ADMIN" "$CHIIPS_DEFAULT_ADMIN_PW"
        fi
        ;;
    *)
        echo "Invalid option. Exiting." | tee -a "$LOGFILE"
        exit 1
        ;;
esac

# Connectivity checks
run_cmd "Pinging OpenShift API" ping -c 3 "$(echo "$AUTH_DEFAULT_URL" | awk -F/ '{print $3}' | cut -d: -f1)"
run_cmd "DNS lookup for OpenShift API" dig "$(echo "$AUTH_DEFAULT_URL" | awk -F/ '{print $3}' | cut -d: -f1)"

# Login to OpenShift
run_cmd "Logging into OpenShift" ../oc login -u "$KUBEADMIN_USER" -p "$KUBEADMIN_PW" --server="$AUTH_DEFAULT_URL" || \
run_cmd "Attempting web login" ../oc login --web --server="$AUTH_DEFAULT_URL"

# Create secret
run_cmd "Creating htpasswd secret" ../oc create secret generic htpass-secret --from-file=htpasswd="$HTPASSWD_FILE" -n openshift-config --dry-run=client -o yaml | ../oc apply -f -

# Apply HTPasswdIdentityProvider CR
run_cmd "Applying htpasswd CR" ../oc apply -f "$(dirname "$0")/htpasswd_cr.yaml"

# Test login
run_cmd "Logging out of OpenShift" ../oc logout
run_cmd "Testing login with default admin" ../oc login -u "$CHIIPS_DEFAULT_ADMIN" --server="$AUTH_DEFAULT_URL"

echo "[$(date "+%Y-%m-%d %H:%M:%S")] IDP htpasswd setup completed successfully." | tee -a "$LOGFILE"
