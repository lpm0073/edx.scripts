#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       feb-2018
#
# usage:      (if your site is in English then you definitely do not need this script)
#             Compile Open edX language translation files.
#             This is required any time you modify language translation tables
#
#
# reference:  https://github.com/edx/edx-platform/wiki/Internationalization-and-localization
#---------------------------------------------------------

# update assets as edxapp user
sudo -H -u edxapp bash << EOF
source /edx/app/edxapp/edxapp_env
cd /edx/app/edxapp/edx-platform
paver i18n_fastgenerate
EOF
