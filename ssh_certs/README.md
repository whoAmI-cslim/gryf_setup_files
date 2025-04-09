### SSH Certs 
These were the SSH certs used during initial setup on the web console. 

You can create your own, but you'll have to add them to the cluster to properly authenticate. These certs will at least get you into the cluster for initial changes if needed.

---

### SSH Private Key Password
- The `.env` file contains `SSH_PRIV_CERT_PW`, which is the password for the private SSH key (if set).
- If you forget whether your key is password-protected, you can check with:

```bash
ssh-keygen -y -f id_ecdsa
```
- If prompted for a passphrase, then the key is password-protected.

---

### Creating Your Own SSH Certs

Generate a new SSH keypair (with optional password):

```bash
ssh-keygen -t ecdsa -b 521 -f id_ecdsa
# You will be prompted to enter a passphrase (password). Leave empty for no password.
```

---

### Adding SSH Certs to OpenShift

1. **Create a secret with your SSH private key and public key**

```bash
oc create secret generic my-ssh-secret \
  --from-file=ssh-privatekey=id_ecdsa \
  --from-file=ssh-publickey=id_ecdsa.pub \
  --type=kubernetes.io/ssh-auth -n your-namespace
```

2. **Link the secret to your builder service account**

```bash
oc secrets link builder my-ssh-secret -n your-namespace
```

3. **(Optional) Link the secret to the default service account**

```bash
oc secrets link default my-ssh-secret -n your-namespace
```

4. **Use the secret in your BuildConfig**

In your `BuildConfig` YAML, under `spec.source.sourceSecret`:

```yaml
source:
  git:
    uri: git@your.git.repo/yourproject.git
  sourceSecret:
    name: my-ssh-secret
```

---

### Notes
- Replace `your-namespace` with your OpenShift project namespace.
- Replace `my-ssh-secret` with your preferred secret name.
- If your SSH key is password-protected, ensure any automation or CI/CD system can handle the passphrase prompt, or consider generating a key without a passphrase for automation purposes.
