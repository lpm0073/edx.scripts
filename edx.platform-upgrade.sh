#!/bin/sh

# McDaniel
# April 2018
#
# Usage:     To upgrade an existing Native Open edX Ubuntu 16.04 64 bit Installation.
#            This script takes about an hour to run. I STRONGLY recommend that you monitor
#            its progress as it runs.
#
#            When attemping Open edX upgrades I've often struggled with subsystem version nuances.
#            The most problematic in my experience are Python pip packages, and pip itself. To
#            attempt to mitigate this problem I prefer to completely delete the existing virtual
#            environments for both Python and Node. The upgrade scripts will automatically rebuild
#            these virtual environments for you using the current recommended versions of each package.
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
# Reference: https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/60227913/Managing+OpenEdX+Tips+and+Tricks
#---------------------------------------------------------
NOW="$(date +%Y%m%dT%H%M%S)"

# Upgrade to the most recent code base. thus far i've found this more reliable than named releases.
export OPENEDX_RELEASE=master

# Step 1: Completely shut down all edX services
sudo /edx/bin/supervisorctl stop edxapp:
sudo /edx/bin/supervisorctl stop edxapp_worker:

sudo /edx/bin/supervisorctl stop analytics_api
sudo /edx/bin/supervisorctl stop certs
sudo /edx/bin/supervisorctl stop discovery
sudo /edx/bin/supervisorctl stop ecommerce
sudo /edx/bin/supervisorctl stop ecomworker
sudo /edx/bin/supervisorctl stop forum
sudo /edx/bin/supervisorctl stop insights
sudo /edx/bin/supervisorctl stop notifier-celery-workers
sudo /edx/bin/supervisorctl stop notifier-scheduler
sudo /edx/bin/supervisorctl stop xqueue
sudo /edx/bin/supervisorctl stop xqueue_consumer

# Step 2: backup the existing environment.

echo "Backing up /edx/app/edxapp/edx-platform/"
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



# Step 3: Perform the upgrade
sudo /edx/bin/update edx-platform ${OPENEDX_RELEASE}
