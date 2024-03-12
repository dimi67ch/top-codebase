#!/bin/bash

# This script executes the whole Ansible playbook

echo "Executing the Playbook..."

ansible-playbook -i ./ansible/inventory.ini ./ansible/playbook.yml

if [ $(echo $?) == 0 ]; then
  echo "Playbook succeeded!"
else
  echo "Something went wrong!"
  exit 1
fi

exit 0