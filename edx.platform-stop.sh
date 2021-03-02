#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       feb-2018
#
# usage:      the correct commands to stop all Open edX services.
#             to restart these service you should reboot your Ubuntu server.
#
# reference:  https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/60227913/Managing+OpenEdX+Tips+and+Tricks
#---------------------------------------------------------


sudo /edx/bin/supervisorctl stop lms
sudo /edx/bin/supervisorctl stop cms
sudo /edx/bin/supervisorctl stop edxapp_worker:

sudo /edx/bin/supervisorctl stop analytics_api
sudo /edx/bin/supervisorctl stop certs
sudo /edx/bin/supervisorctl stop discovery
sudo /edx/bin/supervisorctl stop ecommerce
sudo /edx/bin/supervisorctl stop ecomworker
sudo /edx/bin/supervisorctl stop forum
sudo /edx/bin/supervisorctl stop insights
sudo /edx/bin/supervisorctl stop xqueue
sudo /edx/bin/supervisorctl stop xqueue_consumer
