# Install yum packages
# sudo yum install python3 java-1.8.0-openjdk git libselinux-python3 -y

# Install ansible and other pip packages (if needed)

# curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
# python3 get-pip.py
# python3 -m pip install ansible --user

# Clone opdk accelerator and perform pre - requisite
cd ~
git clone https://github.com/ashwarn/ansible-opdk-accelerator.git
cd ~/ansible-opdk-accelerator/setup
ansible-galaxy install -r requirements.yml -f
ansible-playbook setup.yml

# Select ansible inventory
cp ~/.ansible/multi-planet-configurations/templates/apigee-opdk-configuration-template.cfg ~/.ansible/multi-planet-configurations/prod.cfg
cp -r ~/.ansible/inventory/templates/edge-9-rmp ~/.ansible/inventory/prod/
export ANSIBLE_CONFIG=~/.ansible/multi-planet-configurations/prod.cfg

# Copy license.txt, credentials.yml and replace hosts in ansible_inventory
cp ~/secret/license.txt ~/.apigee-secure/license.txt
cp ~/secret/credentials.yml ~/.apigee-secure/credentials.yml
chmod +x ~/scripts/hostname-replace.sh
~/scripts/hostname-replace.sh

# Update hostname and other vars
sed -i "s/UPDATE_WITH_SSH_USER_NAME/$USERNAME/g" ~/.ansible/multi-planet-configurations/prod.cfg
sed -i 's/TARGET_ENVIRONMENT_NAME_CONVENTION/prod/g' ~/.ansible/multi-planet-configurations/prod.cfg
sed -i "/^apigee_004/s/10.x.x.x/$HOSTNAME/g" ~/.ansible/inventory/prod/edge-dc1


# Setup ssh login
# ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa_ansible -q -N "" 0>&-
# cat ~/.ssh/id_rsa_ansible.pub >> ~/.ssh/authorized_keys
# chmod 600 ~/.ssh/authorized_keys
#
# sed -i 's/id_rsa/id_rsa_ansible/g'  ~/.ansible/multi-planet-configurations/prod.cfg
# sed -i '/^#.*apigee_archive_file_name/s/^#//' ~/.apigee/apigee-mirror-archive-properties.yml

mkdir ~/apigee-4.50.50
cd ~/ansible-opdk-accelerator/installations/multi-node
ansible-galaxy install -r requirements.yml -f

ansible-playbook install-optimized.yml --tags cache,response-file
ansible-playbook install-optimized.yml --tags copy --limit apigee_004
ansible-playbook install-optimized.yml --tags bootstrap --limit apigee_004
ansible-playbook install-optimized.yml --tags rmp --limit apigee_004
