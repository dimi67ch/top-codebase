# GitLab Secrets

These GitLab Secrets are used for the CI/CD pipelines and must be set.

## codebase

- `SSH_HOST_KEY`: SSH public keys of the target (from `~/.ssh/known_hosts`). Get it with:
  ```sh
  cat ~/.ssh/known_hosts | grep <target-ip/domain-name>
  ```

- `SSH_PRIVATE_KEY`: A ssh private key to connect to the target with ssh without password. Needed for the CI/CD. Generate with:
  ```sh
  ssh-keygen
  ```

- `VM_IPADDRESS`: The IP-Address of the target.
