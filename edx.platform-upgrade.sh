#!/bin/sh

# McDaniel
# April 2018
#
# Usage:     To upgrade an existing Native Open edX Ubuntu 20.04 64 bit Installation.
#            This upgrade is based on the original Native installation Ansible Playbook.
#
#            This script takes about an hour to run. I STRONGLY recommend that you monitor
#            its progress as it runs.
#
#            When attemping Open edX upgrades have problems with subsystem version nuances.
#            The most problematic in my experience are Python pip packages, and pip itself. To
#            attempt to mitigate this problem this script deletes the existing virtual
#            environments for both Python and Node. The Ansible playbooks will automatically rebuild
#            these using the current recommended versions of each package.
#
# CRITICALLY IMPORTANT NOTE 1:
#           before attempting this script you should completely backup your server
#           by creating an image of your current EC2 instance on AWS.
#
# CRITICALLY IMPORTANT NOTE 2:
#           This script creates a backup of your currently-installed Open edX code base.
#           This is a large code base in excess of 5Gb. You should verify that the disk volume
#           on your EC2 Ubuntu instance has sufficient available space before attempting to run
#           this script!
#
# CRITICALLY IMPORTANT NOTE 3:
#           a.) This upgrade script will overwrite/replace your nginx virtual server files. if
#           you've modified your nginx configuration for any reason such as to create a proper sub-domain
#           for studio, or to add https then these modifications will be OVERWRITTEN.
#
#           b.) This upgrade script overwrites all four of the configuration json files in /edx/app/edxapp/.
#           However, this script creates backups of these files, which are stored in the same folder.
#
# Reference: https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/60227913/Managing+OpenEdX+Tips+and+Tricks
#---------------------------------------------------------
NOW="$(date +%Y%m%dT%H%M%S)"

# Upgrade to the most recent code base. thus far i've found this more reliable than named releases.
export OPENEDX_RELEASE=master

# Step 1: Completely shut down all edX services
#sudo /edx/bin/supervisorctl stop edxapp:          # for edX platform prior to Ginkgo
sudo /edx/bin/supervisorctl stop lms              # for Ginko and after
sudo /edx/bin/supervisorctl stop lms              # for Ginkgo and after
sudo /edx/bin/supervisorctl stop edxapp_worker:

sudo /edx/bin/supervisorctl stop analytics_api
sudo /edx/bin/supervisorctl stop certs
sudo /edx/bin/supervisorctl stop discovery
sudo /edx/bin/supervisorctl stop ecommerce
sudo /edx/bin/supervisorctl stop ecomworker
sudo /edx/bin/supervisorctl stop forum
sudo /edx/bin/supervisorctl stop insights
#sudo /edx/bin/supervisorctl stop notifier-celery-workers   # for edx platform prior to Koa
#sudo /edx/bin/supervisorctl stop notifier-scheduler        # for edx platform prior to Koa
sudo /edx/bin/supervisorctl stop xqueue
sudo /edx/bin/supervisorctl stop xqueue_consumer

# Step 2: backup the existing environment.
#         You'll need this backup if you've modified any of the source code.
#         Note that you code modifications will NOT be present in the completed upgrade.
#
#         The backups of edxapp_env, venvs and nodeenvs are probably not really necesary.
#         It is safe to delete these three backup folders at any time.

echo "Backing up current version"
  sudo mkdir /edx/etc/BACKUP.${NOW}
  sudo cp /edx/etc/*.yml /edx/etc/BACKUP.${NOW}/

if [ -d /edx/app/edxapp/edx-platform/ ]; then
  sudo mv /edx/app/edxapp/edx-platform/ /edx/app/edxapp/edx-platform-BACKUP-${NOW}
fi

if [ -d /edx/app/edxapp/edxapp_env/ ]; then
  sudo mv /edx/app/edxapp/edxapp_env/ /edx/app/edxapp/edxapp_env-BACKUP-${NOW}
fi

if [ -d /edx/app/edxapp/venvs/ ]; then
  sudo mv /edx/app/edxapp/venvs/ /edx/app/edxapp/venvs-BACKUP-${NOW}
fi

if [ -d /edx/app/edxapp/nodeenvs/ ]; then
  sudo mv /edx/app/edxapp/nodeenvs/ /edx/app/edxapp/nodeenvs-BACKUP-${NOW}
fi



# Step 3: Perform the upgrade. This step takes a VERY long time. Plan on at least
#         45 minutes of waiting around, reading occasional screen output, and drinking lots of coffee.
#
#         A few steps in particular are big, and slow:
#         - cloning the git repository of edx-platform takes around 5 minutes
#         - rebuilding the pip Python virtual environemnt takes around 10 minutes
#         - rebuilding the Node environment takes around 10 minutes
#         - Compiling Static Assets takes around 15 minutes and generates a lot of deprecation messages (which is ok).
sudo /edx/bin/update edx-platform ${OPENEDX_RELEASE}

# I sometimes run into problems with version impcompatabilities during upgrades, especially wth Pip and Python in general.
# In general i've had better success changing my strategy to re-installation than by trying to trouble-shoot the idividual
# problem. Here is the command that you would use if you want to re-install the software rather than update:

#https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/native.sh 
#sudo chmod 755 native.#!/bin/sh
# HEADS UP! -- you need to edit this script, and set the following variable
#                     OPENEDX_RELEASE="master"
#
#sudo ./native.sh
