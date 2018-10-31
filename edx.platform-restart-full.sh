#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       oct-2018
#
# usage:      Full restart of the Open edX platform, including all subsystems.
#
# reference:  https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/60227913/Managing+OpenEdX+Tips+and+Tricks
#---------------------------------------------------------


# These are the commands for restarting the LMS and CMS beginning with Gingko
/edx/bin/supervisorctl restart lms
/edx/bin/supervisorctl restart cms

sudo /edx/bin/supervisorctl restart edxapp_worker:

# Open edX subsystems
sudo /edx/bin/supervisorctl restart analytics_api
sudo /edx/bin/supervisorctl restart certs
sudo /edx/bin/supervisorctl restart discovery
sudo /edx/bin/supervisorctl restart ecommerce
sudo /edx/bin/supervisorctl restart ecomworker
sudo /edx/bin/supervisorctl restart forum
sudo /edx/bin/supervisorctl restart insights
sudo /edx/bin/supervisorctl restart notifier-celery-workers
sudo /edx/bin/supervisorctl restart notifier-scheduler
sudo /edx/bin/supervisorctl restart xqueue
sudo /edx/bin/supervisorctl restart xqueue_consumer

# Generate a status report of all services
sudo /edx/bin/supervisorctl status
