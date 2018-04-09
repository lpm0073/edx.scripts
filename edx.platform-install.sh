#!/bin/sh
# Native Open edX Ubuntu 16.04 64 bit Installation
# McDaniel
# October 2017
#
# To stand up a pristine single-server instance of Open edX Ginkgo.1
# this is a modification of the generic instructions from:
#   Native Open edX Ubuntu 16.04 64 bit Installation
#   https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/146440579/Native+Open+edX+Ubuntu+16.04+64+bit+Installation
#
# This script takes around 2 hours to complete. It is intended to be run unattended, on a background thread using
# nohup.


cd ~

# Prerequisites: ensure that locales are set on your server. if not the ansible boostrap script below will break.
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# Delve into these settings only if you are installing a lanuage other than English
#sudo locale-gen es_ES es_ES.UTF-8
#sudo dpkg-reconfigure locales#sudo dpkg-reconfigure locales

#export LANG=es_ES.UTF-8
#export LC_ALL="es_ES.UTF-8"
#export LC_CTYPE="es_ES.UTF-8"

#export LC_CTYPE=?~@~]es_ES.UTF-8?~@~]
#export LC_NUMERIC=?~@~]es_ES.UTF-8?~@~]
#export LC_TIME=?~@~]es_ES.UTF-8?~@~]
#export LC_COLLATE=?~@~]es_ES.UTF-8?~@~]
#export LC_MONETARY=?~@~]es_ES.UTF-8?~@~]
#export LC_MESSAGES=?~@~]es_ES.UTF-8?~@~]
#export LC_PAPER=?~@~]es_ES.UTF-8?~@~]
#export LC_NAME=?~@~]es_ES.UTF-8?~@~]
#export LC_ADDRESS=?~@~]es_ES.UTF-8?~@~]
#export LC_TELEPHONE=?~@~]es_ES.UTF-8?~@~]
#export LC_MEASUREMENT=?~@~]es_ES.UTF-8?~@~]
#export LC_IDENTIFICATION=?~@~]es_ES.UTF-8?~@~]


# 1. Set the OPENEDX_RELEASE variable:
#export OPENEDX_RELEASE=open-release/ginkgo.1
# Note: there are several small but really important bug fixes since the ginkgo.1 named release. i'm setting the releast to master (ie the most recent stable release) for the time being.
export OPENEDX_RELEASE=master



# 2. Bootstrap the Ansible installation:
wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/ansible-bootstrap.sh -O - | sudo bash

# 3. (Optional) If this is a new installation, randomize the passwords:
wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/generate-passwords.sh -O - | bash

# 4. Install Open edX:
wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/sandbox.sh -O - | bash > install.out
