#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       aug-2019
#
# usage:      compile assets from Ecommerce custom theme
#
#---------------------------------------------------------
echo 'edx.ecommerce-compile-assets.sh'


# compile static assets
sudo su ecommerce -s /bin/bash << EOF
cd ~/ecommerce
source ../ecommerce_env
python manage.py update_assets --themes=rover
python manage.py compress
EOF

# restart Ecommerce
sudo /edx/bin/supervisorctl restart ecommerce
sudo /edx/bin/supervisorctl status ecommerce
