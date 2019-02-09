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
#             Note: if you're planning to modify any of the Sass files for LMS or CMS then
#                   Following are some important variations to the command line arguments that you'll definitely want to know.
#
#              Command:
#                  paver compile_sass
#              Description:
#                  compile sass files for both lms and cms. If command is called like above (i.e. without any arguments) it will
#                  only compile lms, cms sass for the open source theme. None of the theme's sass will be compiled.
#
#              Command:
#                  paver compile_sass --theme-dirs /edx/app/edxapp/edx-platform/themes --themes=red-theme
#              Description:
#                  compile sass files for both lms and cms for 'red-theme' present in '/edx/app/edxapp/edx-platform/themes'
#
#              Command:
#                  paver compile_sass --theme-dirs=/edx/app/edxapp/edx-platform/themes --themes red-theme stanford-style
#              Description:
#                  compile sass files for both lms and cms for 'red-theme' and 'stanford-style' present in
#                  '/edx/app/edxapp/edx-platform/themes'.
#
#              Command:
#                  paver compile_sass --system=cms
#                      --theme-dirs /edx/app/edxapp/edx-platform/themes /edx/app/edxapp/edx-platform/common/test/
#                      --themes red-theme stanford-style test-theme
#              Description:
#                  compile sass files for cms only for 'red-theme', 'stanford-style' and 'test-theme' present in
#                  '/edx/app/edxapp/edx-platform/themes' and '/edx/app/edxapp/edx-platform/common/test/'.
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
#
#
#Following is an example alternative way to call pave that only compiles your custom theme, skipping any others that come pre-shipped with Open edX
#paver --quiet update_assets lms --settings=aws --theme-dirs /edx/app/edxapp/edx-platform/themes --themes=TYPE-YOUR-THEME-NAME-HERE
#paver compile_sass --system=lms --theme-dirs /edx/app/edxapp/edx-platform/themes --themes=TYPE-YOUR-THEME-NAME-HERE
#
#
EOF

# restart edx instances
sudo /edx/bin/supervisorctl restart edxapp:
/edx/bin/supervisorctl restart lms
/edx/bin/supervisorctl restart cms
/edx/bin/supervisorctl restart edxapp_worker:
