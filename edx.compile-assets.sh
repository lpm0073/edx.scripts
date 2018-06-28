#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       feb-2018
#
# usage:      Compile Open edX static assets. See http://edx.readthedocs.io/projects/edx-developer-guide/en/latest/pavelib.html
#             Compiles Coffeescript, Sass, and Xmodule assets, and runs Django's collectstatic.
#
#             This process is required any time you change your custom theme, or if you Add
#             new static assets (like images, pdf documents, custom CSS / JS) to an existing theme.
#
#             Compiling (and "transpiling") assets is the process of translating CSS templates and source files
#             like SASS and Coffee scripts into final CSS files, plus, moving these files from their
#             locations in the code base folder structure to the Nginx locations for hosting purposes.
#             files also pickup codified suffixes as part of this process.
#
# NOTE:       This script initiates the asset compilation process, which takes around 10 minutes to complete.
#             Your Open edX platform will be unavailable during the compilation process.
#
# reference:  https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/60227913/Managing+OpenEdX+Tips+and+Tricks
#---------------------------------------------------------

# update assets as edxapp user
sudo -H -u edxapp bash << EOF
source /edx/app/edxapp/edxapp_env
cd /edx/app/edxapp/edx-platform
paver update_assets lms --settings=aws
paver update_assets cms --settings=aws
EOF

# restart edx instances
sudo /edx/bin/supervisorctl restart edxapp:
/edx/bin/supervisorctl restart lms
/edx/bin/supervisorctl restart cms
/edx/bin/supervisorctl restart edxapp_worker:
