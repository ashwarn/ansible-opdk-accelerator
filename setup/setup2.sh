curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
pip install ansible --user


cd ~

git clone https://github.com/apigee/ansible-opdk-accelerator.git

cd ansible-opdk-accelerator/setup

ansible-galaxy install -r requirements.yml -f

ansible-playbook setup.yml


cp ~/.ansible/multi-planet-configurations/templates/apigee-opdk-configuration-template.cfg ~/.ansible/multi-planet-configurations/prod.cfg

cp -r ~/.ansible/inventory/templates/edge-aio/ ~/.ansible/inventory/prod/

export ANSIBLE_CONFIG=~/.ansible/multi-planet-configurations/prod.cfg

sed -i 's/UPDATE_WITH_SSH_USER_NAME/osboxes/g'  ~/.ansible/multi-planet-configurations/prod.cfg
sed -i 's/TARGET_ENVIRONMENT_NAME_CONVENTION/prod/g'  ~/.ansible/multi-planet-configurations/prod.cfg

sed -i 's/10.x.x.x/localhost/g' ~/.ansible/inventory/prod/inventory-aio

cd ~/ansible-opdk-accelerator/installations/multi-node

ssh-keygen -t rsa 
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

ansible-galaxy install -r requirements.yml -f
ansible-playbook install-optimized.yml


vi ~/.apigee/custom-properties.yml

change the version 

mkdir ~/apigee-4.19.06

edit /home/osboxes/.apigee/apigee-mirror-archive-properties.yml
