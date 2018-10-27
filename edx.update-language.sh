#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       feb-2018
#
# usage:      (if your site is in English then you definitely do not need this script)
#             Download and install Transifex language translation files.
#
#
# reference:
#     https://github.com/edx/edx-platform/wiki/Internationalization-and-localization
#     http://learning.perpetualny.com/blog/multi-language-support-on-open-edx
#---------------------------------------------------------


if [ $# -ne 1 ]; then
    echo "Usage: edx.update-language.sh [Open edX Language Code]"
else
  echo "Updating language" $1

sudo -H -u edxapp bash << EOF
source /edx/app/edxapp/edxapp_env
cd /edx/app/edxapp/edx-platform
tx pull -l $1
EOF

fi
