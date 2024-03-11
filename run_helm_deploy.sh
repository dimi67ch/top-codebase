echo "Deploying via Helm..."
ansible all -i inventory.ini -m include_role -a name=helm_deploy -e @group_vars/all.yml
echo "Deployments succeeded!"
exit 0