#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       aug-2021
#
# usage:      backup MySQL and MongoDB data stores
#             copy to store in "backups" folders in user directory
#             combine into individual tarballs
#             synch tarballs to AWS S3 bucket.
#
# reference:  https://github.com/edx/edx-documentation/blob/master/en_us/install_operations/source/platform_releases/ginkgo.rst
#---------------------------------------------------------

#------------------------------ SUPER IMPORTANT!!!!!!!! -- initialize these variables
S3_BUCKET="YOUR S3 BUCKET NAME"             # For this script to work you'll first need the following:
                                            # - create an AWS S3 Bucket
                                            # - create an AWS IAM user with programatic access and S3 Full Access privileges
                                            # - install AWS Command Line Tools in your Ubuntu EC2 instance
                                            # run aws configure to add your IAM key and secret token
#------------------------------------------------------------------------------------------------------------------------

BACKUPS_DIRECTORY="/home/ubuntu/backups/"
WORKING_DIRECTORY="/home/ubuntu/backup-tmp/"
NUMBER_OF_BACKUPS_TO_RETAIN="10"            # Note: this only regards local storage (ie on the ubuntu server). All backups are retained in the S3 bucket forever.

NOW="$(date +%Y%m%dT%H%M%S)"
SQL_FILE="openedx-mysql-${NOW}"
SQL_TARBALL=${SQL_FILE}.tgz
SQL_FILE=${SQL_FILE}.sql

#Check to see if a working folder exists. if not, create it.
if [ ! -d ${WORKING_DIRECTORY} ]; then
    mkdir ${WORKING_DIRECTORY}
    echo "created backup working folder ${WORKING_DIRECTORY}"
fi

#Check to see if anything is currently in the working folder. if so, delete it all.
if [ -f "$WORKING_DIRECTORY/*" ]; then
  sudo rm -r "$WORKING_DIRECTORY/*"
fi

#Check to see if a backups/ folder exists. if not, create it.
if [ ! -d ${BACKUPS_DIRECTORY} ]; then
    mkdir ${BACKUPS_DIRECTORY}
    echo "created backups folder ${BACKUPS_DIRECTORY}"
fi


cd ${WORKING_DIRECTORY}

# Begin Backup MySQL databases
#------------------------------------------------------------------------------------------------------------------------
echo "Backing up MySQL databases"
tutor local exec -e MYSQL_ROOT_PASSWORD="$(tutor config printvalue MYSQL_ROOT_PASSWORD)" mysql \
    sh -c 'mysqldump --all-databases --password=$MYSQL_ROOT_PASSWORD > /var/lib/mysql/dump.sql'
sudo mv $(tutor config printroot)/data/mysql/dump.sql ${BACKUPS_DIRECTORY}${SQL_FILE}
sudo chown ubuntu ${BACKUPS_DIRECTORY}${SQL_FILE}
sudo chgrp ubuntu ${BACKUPS_DIRECTORY}${SQL_FILE}


#Tarball our mysql backup file
echo "Compressing MySQL backup into a single tarball archive"
tar -czf ${BACKUPS_DIRECTORY}${SQL_FILE}.tgz ${BACKUPS_DIRECTORY}${SQL_FILE}
rm ${BACKUPS_DIRECTORY}${SQL_FILE}
echo "Created tarball of backup data ${SQL_TARBALL}"
# End Backup MySQL databases
#------------------------------------------------------------------------------------------------------------------------


# Begin Backup Mongo
#------------------------------------------------------------------------------------------------------------------------
echo "Backing up MongoDB"
tutor local exec mongodb mongodump --out=/data/db/dump.mongodb
sudo mv $(tutor config printroot)/data/mongodb/dump.mongodb ${BACKUPS_DIRECTORY}/mongo-dump-${NOW}
sudo chown ubuntu ${BACKUPS_DIRECTORY}/mongo-dump-${NOW}
sudo chgrp ubuntu ${BACKUPS_DIRECTORY}/mongo-dump-${NOW}
echo "Done backing up MongoDB"

#Tarball all of our backup files
echo "Compressing backups into a single tarball archive"
tar -czf ${BACKUPS_DIRECTORY}openedx-mongo-${NOW}.tgz ${BACKUPS_DIRECTORY}/mongo-dump-${NOW}
sudo rm -r ${BACKUPS_DIRECTORY}/mongo-dump-${NOW}
echo "Created tarball of backup data openedx-mongo-${NOW}.tgz"
# End Backup Mongo
#------------------------------------------------------------------------------------------------------------------------


#Prune the Backups/ folder by eliminating all but the 30 most recent tarball files
echo "Pruning the local backup folder archive"
if [ -d ${BACKUPS_DIRECTORY} ]; then
  cd ${BACKUPS_DIRECTORY}
  ls -1tr | head -n -${NUMBER_OF_BACKUPS_TO_RETAIN} | xargs -d '\n' rm -f --
fi

#Remove the working folder
echo "Cleaning up"
sudo rm -r ${WORKING_DIRECTORY}

echo "Sync backup to AWS S3 backup folder"
/usr/local/bin/aws s3 sync ${BACKUPS_DIRECTORY} s3://${S3_BUCKET}/backups
echo "Done!"
