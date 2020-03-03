curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
pip install ansible boto botocore boto3 --user

sudo yum install git -y 

cd ~

git clone https://github.com/ashwarn/ansible-opdk-accelerator.git

cd ansible-opdk-accelerator/setup
ansible-galaxy install -r requirements.yml -f
ansible-playbook setup.yml

cp ~/.ansible/multi-planet-configurations/templates/apigee-opdk-configuration-template.cfg ~/.ansible/multi-planet-configurations/prod.cfg
cp -r ~/.ansible/inventory/templates/edge-aio/inventory-aio ~/.ansible/inventory/prod/
export ANSIBLE_CONFIG=~/.ansible/multi-planet-configurations/prod.cfg

sed -i "s/UPDATE_WITH_SSH_USER_NAME/$USERNAME/g"  ~/.ansible/multi-planet-configurations/prod.cfg
sed -i 's/TARGET_ENVIRONMENT_NAME_CONVENTION/prod/g'  ~/.ansible/multi-planet-configurations/prod.cfg

 sed -i "s/10.x.x.x/$HOSTNAME/g" ~/.ansible/inventory/prod/inventory-aio


ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa_ansible -q -N "" 0>&-
cat ~/.ssh/id_rsa_ansible.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

sed -i 's/id_rsa/id_rsa_ansible/g'  ~/.ansible/multi-planet-configurations/prod.cfg
sed -i '/^#.*apigee_archive_file_name/s/^#//' ~/.apigee/apigee-mirror-archive-properties.yml
mkdir ~/apigee-4.19.06
cd ~/ansible-opdk-accelerator/installations/multi-node
ansible-galaxy install -r requirements.yml -f
 
ansible-playbook install-optimized.yml --tags cache,response-file,copy,ds,ms,rmp
#mkdir -p /opt/apigee/data/apigee-mirror/
# copy license and binary 
# cp license.txt ~/.apigee-secure/license.txt
# cp apigee-4.19.06.tar.gz /opt/apigee/data/apigee-mirror/apigee-4.19.06.tar.gz
#sudo chown -R apigee:apigee /opt/apigee/data/apigee-mirror/


#ansible-playbook install-optimized.yml --tags cache,response-file

# vi ~/.apigee/custom-properties.yml

# change the version 

# 

# edit /home/osboxes/.apigee/apigee-mirror-archive-properties.yml
