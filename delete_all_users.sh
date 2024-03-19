#!/bin/bash

# This script deletes all users on the Kubernetes cluster

echo "Executing the Playbook..."

ansible-playbook -i ./ansible/inventory.ini ./ansible/roles/k8s_rbac/extras/delete_all_users.yaml

if [ $(echo $?) == 0 ]; then
  echo "Playbook succeeded!"
else
  echo "Something went wrong!"
  exit 1
fi

exit 0