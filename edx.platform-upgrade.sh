#!/bin/sh
# McDaniel
# April 2018
#
# Usage:     To upgrade an existing Native build.
#            Native Open edX Ubuntu 16.04 64 bit Installation
#
# Reference: Native Open edX Ubuntu 16.04 64 bit Installation
#            https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/146440579/Native+Open+edX+Ubuntu+16.04+64+bit+Installation
#
# This script takes around 2 hours to complete. It is intended to be run unattended, on a background thread using nohup.


cd ~
#sudo rm edx.platform-upgrade.out

# Upgrade to the absolute most recent code base. thus far i've found this more reliable than named releases.
export OPENEDX_RELEASE=master

# Completely shut down all edX services
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

# Upgrade Open edX:
# See: https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/60227913/Managing+OpenEdX+Tips+and+Tricks
sudo /edx/bin/update edx-platform master 

