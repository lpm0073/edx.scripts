#!/bin/sh

# McDaniel
# April 2018
#
# Usage:     To upgrade an existing Native Open edX Ubuntu 16.04 64 bit Installation.
#            This script takes about an hour to run. I STRONGLY recommend that you monitor
#            its progress as it runs.
#
# CRITICALLY IMPORTANT NOTE:
#           before attempting this script you should completely backup your server
#           by creating an image of your current EC2 instance on AWS.
#
# Reference: https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/60227913/Managing+OpenEdX+Tips+and+Tricks
#---------------------------------------------------------

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
  #Check to see if a backup of nodeenvs exists. if so, delete it.
  if [ -d /edx/app/edxapp/edx-platform-BACKUP/ ]; then
    sudo rm -r /edx/app/edxapp/edx-platform-BACKUP/
    echo "found existing backup of /edx/app/edxapp/edx-platform folder. removing"
  fi

  #Check to see if a backup of edxapp_env exists. if so, delete it.
  if [ -d /edx/app/edxapp/edxapp_env-BACKUP/ ]; then
    sudo rm -r /edx/app/edxapp/edxapp_env-BACKUP/
    echo "found existing backup of /edx/app/edxapp/edxapp_env folder. removing"
  fi

  #Check to see if a backup of edxapp_env exists. if so, delete it.
  if [ -d /edx/app/edxapp/venvs-BACKUP/ ]; then
    sudo rm -r /edx/app/edxapp/venvs-BACKUP/
    echo "found existing backup of /edx/app/edxapp/venvs folder. removing"
  fi

  #Check to see if a backup of nodeenvs exists. if so, delete it.
  if [ -d /edx/app/edxapp/nodeenvs-BACKUP/ ]; then
    sudo rm -r /edx/app/edxapp/nodeenvs-BACKUP/
    echo "found existing backup of /edx/app/edxapp/nodeenvs folder. removing"
  fi

  #Backup current Installation
  echo "Backing up /edx/app/edxapp/edx-platform/"
  sudo mv /edx/app/edxapp/edx-platform/ /edx/app/edxapp/edx-platform-BACKUP
  sudo mv /edx/app/edxapp/edxapp_env/ /edx/app/edxapp/edxapp_env-BACKUP
  sudo mv /edx/app/edxapp/venvs/ /edx/app/edxapp/venvs-BACKUP
  sudo mv /edx/app/edxapp/nodeenvs/ /edx/app/edxapp/nodeenvs-BACKUP

# Step 3: Perform the upgrade
sudo /edx/bin/update edx-platform ${OPENEDX_RELEASE}
