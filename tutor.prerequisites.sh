#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       march 21, 2019
#
# usage:      Install Tutor prerequisites.
#
# reference:  https://docs.tutor.overhang.io/quickstart.html
#
# Notes:
#     AWS EC2 Ubuntu 16.04
#     t2-large - 50gb ebs
#
#     Add your dns records!!!!
#      - LMS
#      - LMS preview
#      - CMS
#      - Notes?
#
# Trouble Shooting:
#     ~/.local/share/tutor/env/apps/openedx/
#     tutor local logs nginx
#---------------------------------------------------------

#Install Docker: https://docs.docker.com/install/linux/docker-ce/ubuntu/
#================================
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# check install
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo gpasswd -a $USER docker
sudo usermod -a -G docker $USER
sudo -H -u root bash << EOF
# test Docker installation
docker run hello-world
EOF

#Install Docker Composer: https://docs.docker.com/compose/install/
#================================
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# test installation
docker-compose --version


#Install Tutor: https://docs.tutor.overhang.io/install.html
#================================
sudo curl -L "https://github.com/regisb/tutor/releases/download/latest/tutor-$(uname -s)_$(uname -m)" -o /usr/local/bin/tutor
sudo chmod +x /usr/local/bin/tutor

sudo -H -u root bash << EOF
tutor local quickstart
EOF
