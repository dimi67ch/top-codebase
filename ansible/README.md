# Ansible files

The `ansible` directory contains the files for an automatic setup of the `Kubernetes` environment and deployments of `Helm Charts`.

## Structure
```
.
├── README.md
├── group_vars
├── inventory.ini
├── playbook.yml
└── roles
```

## Components

### group_vars

This directory contains the file `all.yml` which contains the required variables for Ansible such as all **services** to be deployed, **files** to be applied, **users** to be created and the target systems **architecture**.

### inventory.ini

The Ansible inventory file.

### playbook.yml

The Ansible playbook. It executes all the roles. Execute the playbook with:
```bash
./run_playbook.sh
```

### roles

The Roles are like modules of the playbook which are reusable.
We have a role for each installing of `snapd`, `microk8s`, `helm` and the helm deployments (`helm_deploy`), setting up `kubevirt` and creating users with using `k8s_rbac`.

## playbook usage

See [here](../doc/playbook-usage.md).