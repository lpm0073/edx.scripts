#!/bin/bash

rm -rf edx.config-atentamente

git clone https://github.com/atentamente/edx.config-atentamente.git
chown edxapp -R edx.config-atentamente
chgrp edxapp -R edx.config-atentamente

cp /home/ubuntu/edx.config-atentamente/conf/lms.env.json /edx/app/edxapp/lms.env.json
cp /home/ubuntu/edx.config-atentamente/conf/lms.auth.json /edx/app/edxapp/lms.auth.json
cp /home/ubuntu/edx.config-atentamente/conf/cms.env.json /edx/app/edxapp/cms.env.json
cp /home/ubuntu/edx.config-atentamente/conf/cms.auth.json /edx/app/edxapp/cms.auth.json

chmod 644 /edx/app/edxapp/*.env.json
chmod 755 /edx/app/edxapp/*.auth.json
