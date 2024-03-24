#!/bin/bash

# This script executes the Ansible playbook but just the 'helm-deploy' role

echo "Deploying via Helm..."

ansible all -i ../ansible/inventory.ini -m include_role -a name=../ansible/roles/helm_deploy -e @../ansible/group_vars/all.yml

if [ $(echo $?) == 0 ]; then
  echo "Deployments succeeded!"
else
  echo "Something went wrong!"
  exit 1
fi

exit 0
