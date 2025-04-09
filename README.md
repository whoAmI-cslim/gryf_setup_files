# OpenShift Setup Workspace

This workspace contains configuration files, scripts, and credentials to help automate and manage an OpenShift cluster deployment, including NTP, DNS, identity provider, and SSH access.

---

## Directory Overview

### `ntp_configs/`
- **Purpose:** Configure and manage Chrony NTP service for time synchronization.
- **Key files:**
  - `chrony.conf`: Optimized NTP configuration with online and offline fallback.
  - `setup_chrony.sh`: Automated installer with logging, backup, and service management.

### `idp_htpasswd_setup/`
- **Purpose:** Set up OpenShift's HTPasswd identity provider.
- **Key files:**
  - `setup_htpasswd_creds.sh`: Interactive script to add/remove users, create secrets, and configure IDP with logging.
  - `htpasswd_cr.yaml`: OpenShift resource definition for the HTPasswd identity provider.
  - `users.htpasswd`: Generated file containing user credentials.

### `ssh_certs/`
- **Purpose:** Manage SSH keys for authenticating with Git repositories or cluster nodes.
- **Key files:**
  - `id_ecdsa` and `id_ecdsa.pub`: SSH private and public keys.
  - `README.md`: Instructions for generating keys, checking passphrase, and adding SSH secrets to OpenShift.

### `dns_configs/`
- **Purpose:** Configure local DNS resolver using Unbound.
- **Key files:**
  - `unbound.conf`: Unbound DNS server configuration.
  - `setup_unbound.sh`: Script to install and configure Unbound.

### `.env`
- **Purpose:** Store environment variables used by setup scripts.
- **Contains:** OpenShift credentials, API URLs, SSH key passphrase, and default admin user info.

### `network`
- **Purpose:** Provide initial understanding of required IP schemas and hostname configurations.
- **Contains:** System IP breakdown for critical services for initial server setup.

### `openshift_binaries`
- **Purpose:** Provide needed utility binaries to interact with Openshift.
- **Contains:** The oc and kubectl binaries. Users should move these into their local bin folders for use. 

### `kubeconfig.yaml & chiips-openshift-installation.iso`
- **Purpose:** Provision the needed server software to standup Openshift.
- **Contains:** The automated installation iso and kubeconfig.yaml needed for setup.

---

## Usage Notes

- Review and customize the `.env` file with your environment-specific values.
- Run the setup scripts in each directory to configure services and OpenShift components.
- SSH keys can be generated or replaced as needed, then added to OpenShift as secrets.
- The workspace is designed to be portable and reproducible for OpenShift cluster setup.
