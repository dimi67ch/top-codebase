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

This directory contains the file `all.yml` which contains the required variables for Ansible such as all services to be deployed.

### inventory.ini

The Ansible inventory file.

### playbook.yml

The Ansible playbook. It executes all the roles. Execute the playbook with:
```bash
ansible-playbook -i inventory.ini playbook.yaml
```

### roles

The Roles are like modules of the playbook which are reusable.
We have a role for each installing of `snapd`, `microk8s`, `helm` and the helm deployments (`helm_deploy`).