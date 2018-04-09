#!/bin/bash
#---------------------------------------------------------
# written by: mcdaniel
# date:       feb-2018
#
# usage:      backup MySQL and MongoDB data stores
#             combine into a single tarball, store in "backups" folders in user directory
#
# reference:  https://github.com/edx/edx-documentation/blob/master/en_us/install_operations/source/platform_releases/ginkgo.rst
#---------------------------------------------------------

BACKUPS_DIRECTORY="/home/ubuntu/backups/"
WORKING_DIRECTORY="/home/ubuntu/backup-tmp/"

if [ ! -d "$WORKING_DIRECTORY" ]; then
    mkdir "$WORKING_DIRECTORY"
    echo "created backup working folder ${WORKING_DIRECTORY}"
fi

if [ -f "$WORKING_DIRECTORY/*" ]; then
  sudo rm -r "$WORKING_DIRECTORY/*"
fi

cd "$WORKING_DIRECTORY"

#Backup MySQL databases
MYSQL_CONN="-uroot"
echo "Reading MySQL database names..."
mysql ${MYSQL_CONN} -ANe "SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ('mysql','information_schema','performance_schema')" > /tmp/db.txt
DBS="--databases $(cat /tmp/db.txt)"
NOW="$(date +%Y%m%dT%H%M%S)"
SQL_FILE="mysql-data-${NOW}.sql"
echo "Dumping MySQL structures..."
mysqldump ${MYSQL_CONN} --add-drop-database --no-data ${DBS} > ${SQL_FILE}
echo "Dumping MySQL data..."
# If there is table data you don't need, add --ignore-table=tablename
mysqldump ${MYSQL_CONN} --no-create-info ${DBS} >> ${SQL_FILE}
echo "Done backing up MySQL"

#Backup Mongo
for db in edxapp cs_comment_service_development; do
    echo "Dumping Mongo db ${db}..."
    mongodump -u admin -p'Ke0SEpfrBBZ57z44KKfIMZfnYjjJVZEuD4T' -h localhost --authenticationDatabase admin -d ${db} --out mongo-dump-${NOW}
done
echo "Done backing up MongoDB"

#Check to see if a backups/ folder exists. if not, create it.
if [ ! -d "$BACKUPS_DIRECTORY" ]; then
    mkdir "$BACKUPS_DIRECTORY"
    echo "created backups folder ${BACKUPS_DIRECTORY}"
fi

#Tarball all of our backup files
tar -czf /home/ubuntu/backups/openedx-data-${NOW}.tgz ${SQL_FILE} mongo-dump-${NOW}
sudo chown ubuntu /home/ubuntu/backups/openedx-data-${NOW}.tgz
sudo chgrp ubuntu /home/ubuntu/backups/openedx-data-${NOW}.tgz
echo "Created tarball of backup data openedx-data-${NOW}.tgz"

#Prune the Backups/ folder by eliminating all but the 30 most recent tarball files
if [ -d "$BACKUPS_DIRECTORY" ]; then
  cd "$BACKUPS_DIRECTORY"
  ls -1tr | head -n -15 | xargs -d '\n' rm -f --
fi

#Remove the working folder
echo "Cleaning up"
sudo rm -r "$WORKING_DIRECTORY"

echo "Sync backup to AWS S3 backup folder"
aws s3 sync /home/ubuntu/backups s3://educacion.atentamente.mx/backups
echo "Done!"

