#!/bin/bash

# This script creates n users on the Kubernetes cluster

echo "Executing the Playbook..."

ansible-playbook -i ../ansible/inventory.ini ../ansible/roles/k8s_rbac/extras/create_users.yaml

if [ $(echo $?) == 0 ]; then
  echo "Playbook succeeded!"
else
  echo "Something went wrong!"
  exit 1
fi

exit 0