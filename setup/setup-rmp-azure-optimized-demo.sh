export ANSIBLE_CONFIG=~/.ansible/multi-planet-configurations/prod.cfg
cd ~/ansible-opdk-accelerator/installations/multi-node

ansible-playbook install-optimized.yml --tags cache,response-file
ansible-playbook install-optimized.yml --tags copy --limit apigee_004
ansible-playbook install-optimized.yml --tags bootstrap --limit apigee_004
ansible-playbook install-optimized.yml --tags rmp --limit apigee_004
