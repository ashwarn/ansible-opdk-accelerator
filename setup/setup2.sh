curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
pip install ansible --user


cd ~

git clone https://github.com/ashwarn/ansible-opdk-accelerator.git

cd ansible-opdk-accelerator/setup

ansible-galaxy install -r requirements.yml -f

ansible-playbook setup.yml


cp ~/.ansible/multi-planet-configurations/templates/apigee-opdk-configuration-template.cfg ~/.ansible/multi-planet-configurations/prod.cfg

cp -r ~/.ansible/inventory/templates/edge-2/ ~/.ansible/inventory/prod/

export ANSIBLE_CONFIG=~/.ansible/multi-planet-configurations/prod.cfg

USER=`whoami`



sed -i "s/UPDATE_WITH_SSH_USER_NAME/$USER/g"  ~/.ansible/multi-planet-configurations/prod.cfg
sed -i 's/TARGET_ENVIRONMENT_NAME_CONVENTION/prod/g'  ~/.ansible/multi-planet-configurations/prod.cfg

sed -i "s/10.x.x.x/$HOSTNAME/g" ~/.ansible/inventory/prod/edge-dc1

cd ~/ansible-opdk-accelerator/installations/multi-node

ssh-keygen -b 2048 -t rsa -f /tmp/id_rsa_ansible -q -N "" 0>&-

cat ~/.ssh/id_rsa_ansible.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

sed -i 's/id_rsa/id_rsa_ansible/g'  ~/.ansible/multi-planet-configurations/prod.cfg

cd ansible-opdk-accelerator/installations/multi-node
ansible-galaxy install -r requirements.yml -f
ansible-playbook install-optimized.yml


# vi ~/.apigee/custom-properties.yml

# change the version 

# mkdir ~/apigee-4.19.06

# edit /home/osboxes/.apigee/apigee-mirror-archive-properties.yml
