#!/bin/bash

# Ansible configuration
yum update -y
yum install git -y
yum install gcc libffi-devel python-devel openssl-devel -y
easy_install pip
pip install -U setuptools
pip install -U awscli
pip install ansible==${ansible_version}


# Setup aws cli default region for root user
mkdir -p /root/.aws
cat > /root/.aws/config << EOF
[default]
output = json
region = eu-central-1
EOF

export HOME=/root
# configure git
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true


# Run ansible-pull
cd /opt
git clone ${ansible_pull_repo} ansible
cd /opt/ansible
ansible-playbook local.yml 2>&1 | tee -a /var/log/ansible-pull.log

# Custom userdata
${custom_userdata}