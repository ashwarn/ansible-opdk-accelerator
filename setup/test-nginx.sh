rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y nginx
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
systemctl start nginx
