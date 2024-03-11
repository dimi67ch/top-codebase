echo "Executing the Playbook..."
ansible-playbook -i ./ansible/inventory.ini ./ansible/playbook.yml
echo "Playbook succeeded!"
exit 0